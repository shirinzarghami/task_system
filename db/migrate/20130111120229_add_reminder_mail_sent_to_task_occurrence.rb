class AddReminderMailSentToTaskOccurrence < ActiveRecord::Migration
  def change
    add_column :task_occurrences, :reminder_mail_sent, :boolean, default: false, nil: false
  end
end
