class TaskOccurrence < ActiveRecord::Base
  attr_accessible :checked, :completed_at, :deadline, :remarks, :task_id, :user_id

  belongs_to :task, dependant: :destroy
  
  validates :task_id, presence: true

end
