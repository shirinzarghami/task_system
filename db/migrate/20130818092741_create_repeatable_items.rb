class CreateRepeatableItems < ActiveRecord::Migration
  def change
    create_table :repeatable_items do |t|
      t.string :repeat_every_unit
      t.integer :repeat_number, default: 0, nil: 0
      t.boolean :repeat_infinite, default: true, nil: true
      t.datetime :next_occurrence
      t.string :only_on_week_days
      t.integer :repeat_every_number, default: 0, nil: 0
      t.integer :repeatable_id
      t.string :repeatable_type
      t.string :deadline_unit
      t.integer :deadline_number, default: 0, nil: 0
      t.boolean :has_deadline, default: true, nil: true
      t.boolean :enabled, default: true, nil: true
      t.timestamps
    end
  end
end
