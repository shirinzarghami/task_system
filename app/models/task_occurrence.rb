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
    self.user = task.next_user
  end

  def completed?
    task.should_be_checked ? checked : deadline < Time.now
  end

  def too_late?
    if completed?
      completed_at.present? and completed_at > deadline
    else
      Time.now.utc > deadline.utc
    end
  end

  private
    def set_initial_values
      checked = false if checked.nil?
    end
end
