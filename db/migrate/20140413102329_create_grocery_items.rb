class CreateGroceryItems < ActiveRecord::Migration
  def change
    create_table :grocery_items do |t|
      t.string :name
      t.integer :number
      t.datetime :deadline
      t.string :brand
      t.integer :community_id
      t.integer :user_id

      t.timestamps
    end
  end
end
