class TaskOccurrence < ActiveRecord::Base
  attr_accessible :checked, :completed_at, :deadline, :remarks, :task_id, :user_id

  belongs_to :task, dependent: :destroy
  
  validates :task_id, presence: true

  scope :latest, order('created_at').limit(1)

end
