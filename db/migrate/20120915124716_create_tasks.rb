class CreateTasks < ActiveRecord::Migration
  def change
    create_table :tasks do |t|
      t.string :name
      t.text :description
      t.integer :time
      t.integer :deadline
      t.boolean :should_be_checked
      t.integer :user_order_id
      t.integer :interval
      t.datetime :last_occurrence
      t.integer :user_id
      t.integer :community_id
      t.integer :repeat
      t.date :start_on
      t.string :allocation_mode
      t.integer :allocated_user_id

      t.timestamps
    end
  end
end
