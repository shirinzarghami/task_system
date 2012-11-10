class TaskOccurrence < ActiveRecord::Base
  attr_accessible :checked, :completed_at, :deadline, :remarks, :task_id, :user_id

  belongs_to :task, dependent: :destroy
  belongs_to :user
  
  validates :task_id, presence: true

  scope :latest, order('created_at').limit(1)

  after_initialize :set_initial_values

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

  private
    def set_initial_values
      checked = false if checked.nil?
    end

    def allocate_in_turns
      ordered_id_list = task.user_order.split(',')
      previous_occurrence = task.task_occurrences.latest.first

      previous_user_id = (previous_occurrence.present? ? previous_occurrence.user.id : ordered_id_list.first)
      next_user_id = ordered_id_list.rotate(ordered_id_list.index(previous_user_id.to_s)).second

      # allocate to creater of task when next user is not found
      task.community.members.find_by_id(next_user_id) || task.user
    end

    def allocate_by_time
      
    end

    def allocate_by_time_all
      
    end
end