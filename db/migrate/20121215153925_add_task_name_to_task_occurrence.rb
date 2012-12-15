class AddTaskNameToTaskOccurrence < ActiveRecord::Migration
  def change
    add_column :task_occurrences, :task_name, :string
    add_column :task_occurrences, :should_be_checked, :boolean, default: true, nil: false
  end
end
