class AddIsCompensationToTaskOccurrence < ActiveRecord::Migration
  def change
    add_column :task_occurrences, :is_compensation, :boolean, default: false, nil: false
  end
end
