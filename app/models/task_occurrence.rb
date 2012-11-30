class TaskOccurrence < ActiveRecord::Base
  include ActiveModel::ForbiddenAttributesProtection
  attr_accessible :checked, :completed_at, :deadline, :remarks, :task_id, :user_id

  belongs_to :task
  belongs_to :user
  
  validates :task_id, presence: true
  validates :user_id, presence: true

  scope :latest, order('created_at').limit(1)
  scope :for_user, lambda {|user| where(user_id: user.id)}
  scope :for_community, lambda {|community| joins(:task).where(['tasks.community_id = ?', community.id])}

  # Not completed occurrences
  scope :todo, joins(:task).where('
                                  (tasks.should_be_checked = true AND task_occurrences.checked = false)
                                  OR 
                                  (tasks.should_be_checked = false AND UTC_TIMESTAMP() < task_occurrences.deadline)')

  scope :completed, joins(:task).where('
                                  (tasks.should_be_checked = true AND task_occurrences.checked = true)
                                  OR 
                                  (tasks.should_be_checked = false AND UTC_TIMESTAMP() >= task_occurrences.deadline)')

  after_initialize :set_initial_values

  def checked= value
    if value
      self[:checked] = true
      self.completed_at = Time.now
    else
      self[:checked] = false
      self.completed_at = nil
    end
  end

  def allocate
    self.user = case task.allocation_mode
    when 'in_turns' then allocate_in_turns
    when 'time' then allocate_by_time
    when 'time_all' then allocate_by_time_all
    when 'user' then task.allocated_user
    end
  end

  def completed?
    task.should_be_checked ? checked : deadline < Time.now
  end

  def too_late?
    completed_at.present? and completed_at <= deadline
  end

  private
    def set_initial_values
      checked = false if checked.nil?
    end

    def allocate_in_turns
      ordered_id_list = task.user_order.split(',')
      previous_occurrence = task.task_occurrences.latest.first
      previous_user_id = (previous_occurrence.present? ? previous_occurrence.user.id : ordered_id_list.last)
      next_user_id = ordered_id_list.include?(previous_user_id.to_s) ? ordered_id_list.rotate(ordered_id_list.index(previous_user_id.to_s) + 1).first : nil

      # allocate to creater of task when next user is not found
      task.community.members.find_by_id(next_user_id) || task.user
    end

    def allocate_by_time
      
    end

    def allocate_by_time_all
      
    end
end
