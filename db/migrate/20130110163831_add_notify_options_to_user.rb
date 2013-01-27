class AddNotifyOptionsToUser < ActiveRecord::Migration
  def change
    add_column :users, :receive_comment_mail, :boolean, default: true, nil: true
 

  end
end
