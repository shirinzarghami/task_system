class AddIgnoredUsersToTask < ActiveRecord::Migration
  def change
    add_column :tasks, :ignored_user_ids, :string
  end
end
