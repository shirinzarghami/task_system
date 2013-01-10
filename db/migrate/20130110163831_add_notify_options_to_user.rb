class AddNotifyOptionsToUser < ActiveRecord::Migration
  def change
    add_column :users, :notify_comment, :boolean, default: true, nil: true
    add_column :users, :notify_task_occurrence, :boolean, default: true, nil: true
    add_column :users, :notify_remind_task_occurrence, :boolean, default: true, nil: true

  end
end
