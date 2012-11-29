class CreateTaskOccurrences < ActiveRecord::Migration
  def change
    create_table :task_occurrences do |t|
      t.integer :task_id
      t.boolean :checked, default: false, nil: false
      t.datetime :deadline
      t.text :remarks
      t.integer :user_id
      t.datetime :completed_at

      t.timestamps
    end
  end
end
