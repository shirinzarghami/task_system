class TaskOccurrence < ActiveRecord::Base
  include ActiveModel::ForbiddenAttributesProtection
  attr_accessible :checked, :completed_at, :deadline, :remarks, :task_id, :user_id

  belongs_to :task
  belongs_to :user
  
  acts_as_commentable
    
  validates :task_id, presence: true
  validates :task_name, presence: true
  validates :time_in_minutes, presence: true, :numericality => {:greater_than_or_equal_to => 0}

  scope :latest, order('created_at DESC').limit(1)
  scope :for_user, lambda {|user| where(user_id: user.id)}
  scope :for_user_or_open, lambda {|user| where(['task_occurrences.user_id = ? OR task_occurrences.user_id IS NULL', user.id])}
  scope :for_community, lambda {|community| joins(:task).where(['tasks.community_id = ?', community.id])}
  scope :for_task, lambda {|task| where(task_id: task.id)}
  scope :to_email, where(should_send_assign_mail: true)
  scope :approaching_deadline, where(['task_occurrences.deadline < (UTC_TIMESTAMP() + INTERVAL 1 DAY)'])
  scope :no_reminder_sent, where(reminder_mail_sent: false)
  # Not completed occurrences
  scope :todo, joins(:task).order('task_occurrences.deadline ASC').where('
                                  (tasks.should_be_checked = true AND task_occurrences.checked = false)
                                  OR 
                                  (tasks.should_be_checked = false AND UTC_TIMESTAMP() < task_occurrences.deadline)')

  scope :completed, joins(:task).order('task_occurrences.updated_at DESC').where('
                                  (tasks.should_be_checked = true AND task_occurrences.checked = true)
                                  OR 
                                  (tasks.should_be_checked = false AND UTC_TIMESTAMP() >= task_occurrences.deadline)')

  after_initialize :set_default_values

  def self.send_reminders
    approaching_deadline.no_reminder_sent.select(:user_id).group(:user_id).each do |user_id|
      ActiveRecord::Base.transaction do 
        task_occurrences = approaching_deadline.no_reminder_sent.where(user_id: user_id)
        user = User.find user_id
        TaskOccurrenceMailer.remind user, task_occurrences
        task_occurrences.update_all! reminder_mail_sent: true
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
    if user.present? and user.notify_task_occurrence
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
    task.should_be_checked ? checked : deadline < Date.today
  end

  def too_late?
    if completed?
      completed_at.present? and completed_at.localtime.to_date > deadline
    else
      Date.today > deadline
    end
  end

  def time
    Time.mktime(0) + (time_in_minutes * 60)
  end

  private
    def set_default_values
      checked = false if checked.nil?
    end
end
