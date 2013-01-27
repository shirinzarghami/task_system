class CreateTaskOccurrences < ActiveRecord::Migration
  def change
    create_table :task_occurrences do |t|
      t.integer :task_id
      t.boolean :checked, default: false, nil: false
      t.date :deadline
      t.text :remarks
      t.integer :user_id
      t.datetime :completed_at
      t.integer :time_in_minutes, default: 0, nil: 0

      t.timestamps
    end
  end
end
