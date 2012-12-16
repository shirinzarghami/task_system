class AddTaskNameToTaskOccurrence < ActiveRecord::Migration
  def change
    add_column :task_occurrences, :task_name, :string
    add_column :task_occurrences, :should_be_checked, :boolean, default: true, nil: false

    add_column :task_occurrences, :should_send_assign_mail, :boolean, default: false, nil: false
    add_column :users, :receive_assign_mail, :boolean, default: true, nil: true
    add_column :users, :receive_reminder_mail, :boolean, default: true, nil: true
  end
end
