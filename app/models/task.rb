class Task < ActiveRecord::Base
  include ActiveModel::ForbiddenAttributesProtection
  ALLOCATION_MODES = [:in_turns, :time, :time_all, :voluntary, :user]
  ALLOCATION_MODES_FORM = Task::ALLOCATION_MODES.map {|m| [I18n.t("activerecord.attributes.task.allocation_modes.#{m.to_s}"), m]} 

  TIME_UNITS = {
    days: 1.day,
    weeks: 1.week,
    months: 1.month
  }

  attr_accessible :allocated_user_id, :allocation_mode, :deadline, :description, :interval, :next_occurrence, :name, :repeat, :should_be_checked, :time, :user_id, :user_order, :instantiate_automatically, :interval_unit, :repeat_infinite, :deadline_unit, :user

  belongs_to :community
  belongs_to :user # Creator of the task
  belongs_to :allocated_user, class_name: 'User'
  has_many :task_occurrences
  
  validates :name, presence: true, length: {maximum: 50, minimum: 3}
  validates :time, presence: true, :numericality => {:greater_than => 0}
  validates :interval, :numericality => {:greater_than => 0}
  validates :deadline, presence: true, :numericality => {:greater_than_or_equal_to => 0}
  validates :user_order, format: {with: /(\d+)(,\d+)*/} 
  validates :repeat, presence: true, :numericality => {:greater_than_or_equal_to => 0}
  validates :deadline_unit, presence: true, :inclusion => { :in => Task::TIME_UNITS.keys.map(&:to_s) }
  validates :interval_unit, :inclusion => { :in => Task::TIME_UNITS.keys.map(&:to_s) }
  validates :allocation_mode, inclusion: {in: Task::ALLOCATION_MODES.map(&:to_s)}
  validates :user_id, presence: true

  after_initialize :set_default_values

  scope :to_schedule, where(instantiate_automatically: true).where("tasks.next_occurrence <= UTC_TIMESTAMP()").where("tasks.repeat_infinite = true OR tasks.repeat > 0")

  class << self
    def schedule_upcoming_occurrences
      Task.to_schedule.each {|task| task.schedule({}, hold_email: true)}
      
      # User.joins(:task_occurrences).group('users.id').where('task_occurrences.should_send_assign_mail = true').each do |user|
      TaskOccurrence.group('user_id').where(should_send_assign_mail: true).where('user_id IS NOT NULL').each do |task_occurrence|  
        # Send email
        TaskOccurrenceMailer.assign(task_occurrence.user).deliver
        TaskOccurrence.where(user_id: task_occurrence.user.id).update_all(should_send_assign_mail: false)
      end
    end 
  end

  def schedule task_occurrences_params = {}, options = {hold_email: false}
    ActiveRecord::Base.transaction do
      task_occurrence = task_occurrences.build task_occurrences_params
      task_occurrence.deadline = Time.now + deadline_time
      task_occurrence.time_in_minutes = self.time_in_minutes
      task_occurrence.allocate if task_occurrence.user.nil?
      task_occurrence.task_name = self.name
      task_occurrence.should_be_checked = self.should_be_checked
      task_occurrence.community = self.community

      task_occurrence.send_email hold: options[:hold_email]
      self.next_occurrence += self.interval_time
      self.repeat-=1 if !self.repeat_infinite and self.repeat > 0
      self.save!
    end
  end

  def next_allocated_user
    case allocation_mode
      when 'in_turns' then allocate_in_turns
      when 'time' then allocate_by_time
      when 'time_all' then allocate_by_time_all
      when 'voluntary' then nil
      when 'user' then allocated_user
    end
  end

  def instantiate_in_words
    t_root = 'activerecord.attributes.task.instantiate'
    if instantiate_automatically 
      I18n.t("#{t_root}.#{interval_unit}", count: interval)
    else
      I18n.t("#{t_root}.manual")
    end
  end

  def deadline_in_words
    t_root = 'activerecord.attributes.task.deadline-info'
    I18n.t("#{t_root}.#{deadline_unit}", count: deadline)
  end

  def interval_time
    eval "#{interval}.#{interval_unit}" if TIME_UNITS.keys.include?(interval_unit.to_sym)
  end

  def deadline_time
    eval "#{deadline}.#{deadline_unit}" if TIME_UNITS.keys.include?(deadline_unit.to_sym)
  end

  def ordered_members
    ordered_member_ids = check_ordered_members_string
    # Sort members based on the attribute 'user_order' (list of ids)
    self.community.members.sort {|a,b| ordered_member_ids.index(a.id) <=> ordered_member_ids.index(b.id) }
  end

  def time_in_minutes
    time.hour * 60 + time.min
  end

  
  private
    def set_default_values
      self.instantiate_automatically = true if self.instantiate_automatically.nil?
      self.user_order ||= self.community.members.map {|m| m.id}.compact.join(',') if self.community.present?
      self.interval ||= 1
      self.deadline ||= 1
      self.time ||= Time.at(0) + 30.minutes
      self.next_occurrence ||= Date.today
      self.repeat ||= 0
      self.repeat_infinite = true if self.repeat_infinite.nil?
    end

    def check_ordered_members_string
      ordered_member_ids = self.user_order.split(',').map(&:to_i)
      community_member_ids = self.community.members.map(&:id)

      unless ordered_member_ids.sort == community_member_ids.sort
        # Add new community members to the ordered list
        community_member_ids.each {|member_id| ordered_member_ids << member_id unless ordered_member_ids.include?(member_id)}
        # Remove members from the order list that are no langer part of the community
        ordered_member_ids = ordered_member_ids.map {|member_id| community_member_ids.include?(member_id)}
        self.update_attributes user_order: ordered_member_ids.join(',')
      end
      ordered_member_ids
    end

    def allocate_in_turns
      ordered_id_list = user_order.split(',')
      previous_occurrence = task_occurrences.latest.first
      previous_user_id = (previous_occurrence.present? ? previous_occurrence.user.id : ordered_id_list.last)
      next_user_id = ordered_id_list.include?(previous_user_id.to_s) ? ordered_id_list.rotate(ordered_id_list.index(previous_user_id.to_s) + 1).first : nil

      # allocate to creater of task when next user is not found
      community.members.find_by_id(next_user_id) || user
    end

    def allocate_by_time
      least_time_user_id = TaskOccurrence.joins("RIGHT OUTER JOIN community_users ON task_occurrences.user_id = community_users.user_id").where(["(task_occurrences.task_id = ? OR task_occurrences.task_id IS NULL)", id]).group("community_users.user_id").order("sum_time_in_minutes").sum(:time_in_minutes).keys.first
      # User.find least_time_user_id
      # debugger
      least_time_user_id.nil? ? community.members.first : community.members.find(least_time_user_id)
    end

    def allocate_by_time_all
      least_time_user_id = TaskOccurrence.joins("RIGHT OUTER JOIN community_users ON task_occurrences.user_id = community_users.user_id").where(["community_users.community_id = ? ", community.id]).group("community_users.user_id").order("sum_time_in_minutes").sum(:time_in_minutes).keys.first
      # User.find least_time_user_id
      least_time_user_id.nil? ? community.members.first : community.members.find(least_time_user_id)
    end


end
