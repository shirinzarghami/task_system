class CreateEventOccurrences < ActiveRecord::Migration
  def change
    create_table :event_occurrences do |t|
      t.datetime :starts_at
      t.datetime :register_deadline
      t.integer :event_id

      t.timestamps
    end
  end
end
