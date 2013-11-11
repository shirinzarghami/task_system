class CreateEventRoles < ActiveRecord::Migration
  def change
    create_table :event_roles do |t|
      t.string :name
      t.time :time
      t.boolean :has_task_occurrence
      t.integer :max_users
      t.integer :event_id

      t.timestamps
    end
  end
end
