class AddUserIdToCommunity < ActiveRecord::Migration
  def change
    add_column :communities, :creator_id, :integer
  end
end
