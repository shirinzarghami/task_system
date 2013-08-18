class AddNotificationSentToComment < ActiveRecord::Migration
  def change
    add_column :comments, :notification_sent, :boolean, default: false, nil: false
    add_index :comments, :notification_sent
  end
end
