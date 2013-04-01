class RenameUserOrderToUserOrderIds < ActiveRecord::Migration

  def change
    # rename_column :tasks, :user_order, :user_order_ids
    rename_column :tasks, :user_order, :ordered_user_ids
  end
end
