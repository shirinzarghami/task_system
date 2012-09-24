class CreateTasks < ActiveRecord::Migration
  def change
    create_table :tasks do |t|
      t.string :name
      t.text :description
      t.time :time
      t.integer :deadline
      t.string :deadline_unit
      t.boolean :should_be_checked
      t.integer :interval
      t.string :interval_unit
      t.datetime :last_occurrence
      t.integer :user_id
      t.integer :community_id
      t.integer :repeat
      t.date :start_on
      t.string :allocation_mode
      t.integer :allocated_user_id
      t.boolean :instantiate_automatically
      t.boolean :repeat_infinite
      t.string :user_order
      t.timestamps
    end
  end
end
