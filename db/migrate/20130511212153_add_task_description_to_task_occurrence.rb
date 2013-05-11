class AddTaskDescriptionToTaskOccurrence < ActiveRecord::Migration
  def change
    add_column :task_occurrences, :task_description, :text
  end
end
