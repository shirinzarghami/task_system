class TaskOccurrence < ActiveRecord::Base
  include ActiveModel::ForbiddenAttributesProtection
  attr_accessible :checked, :completed_at, :deadline, :remarks, :task_id, :user_id, :time_in_minutes, :should_be_checked, :task_name, :task_description

  belongs_to :task
  belongs_to :user
  belongs_to :community  
  acts_as_commentable
    
  # validates :task_id, presence: true
  validates :task_name, presence: true
  validates :time_in_minutes, presence: true, :numericality => {:greater_than_or_equal_to => 0}
  validates :community_id, presence: true

  scope :latest, order('created_at DESC').limit(1)
  scope :for_user, lambda {|user| where(user_id: user.id)}
  # Open means voluntary (no user assigned)
  scope :for_user_or_open, lambda {|user| where(['task_occurrences.user_id = ? OR task_occurrences.user_id IS NULL', user.id])}
  scope :for_task, lambda {|task| where(task_id: task.id)}
  scope :to_email, where(should_send_assign_mail: true)
  scope :approaching_deadline, where(['task_occurrences.deadline < (UTC_TIMESTAMP() + INTERVAL 1 DAY)'])
  scope :no_reminder_sent, where(reminder_mail_sent: false)

  scope :todo, order('task_occurrences.deadline ASC').where('
                                  (should_be_checked = true AND checked = false)
                                  OR 
                                  (should_be_checked = false AND UTC_TIMESTAMP() < deadline)')



  scope :completed, order('task_occurrences.updated_at DESC').where('
                                  (should_be_checked = true AND checked = true)
                                  OR 
                                  (should_be_checked = false AND UTC_TIMESTAMP() >= deadline)')  

  scope :uncompleted, order('task_occurrences.updated_at DESC').where('
                                  (should_be_checked = true AND checked = false)
                                  OR 
                                  (should_be_checked = false AND UTC_TIMESTAMP() <= deadline)')


  after_initialize :set_default_values

  def self.send_reminders
    # uncompleted.approaching_deadline.no_reminder_sent.select(:user_id).group(:user_id).each do |result|
    joins(:user).uncompleted.approaching_deadline.no_reminder_sent.select(:user_id).group(:user_id).where('users.receive_reminder_mail IS true').each do |result|
      ActiveRecord::Base.transaction do 
        task_occurrences = approaching_deadline.no_reminder_sent.where(user_id: result.user_id)
        user = User.find result.user_id
        task_occurrences.update_all reminder_mail_sent: true
        # next unless user.receive_reminder_mail
        TaskOccurrenceMailer.reminder(user, task_occurrences).deliver
      end
    end
  end

  def checked= value
    if value
      self[:checked] = true
      self.completed_at = Time.now
    else
      self[:checked] = false
      self.completed_at = nil
    end
  end

  def send_email options = {hold: false}
    if user.present? and user.receive_assign_mail
      if options[:hold]
        self.should_send_assign_mail = true
      else
        TaskOccurrenceMailer.assign(user, self).deliver
      end
    end
  end

  def allocate
    self.user = task.next_allocated_user
  end

  def completed?
    should_be_checked ? checked : deadline < Date.today
  end

  def too_late?
    if completed?
      completed_at.present? and completed_at.localtime.to_date > deadline
    elsif deadline.present?
      Date.today > deadline
    else
      false
    end
  end

  def time
    Time.mktime(0) + (time_in_minutes * 60)
  end

  def title
    task_name
  end

  private
    def set_default_values
      checked = false if checked.nil?
    end
end
