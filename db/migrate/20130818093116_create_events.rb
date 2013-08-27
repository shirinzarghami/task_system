class CreateEvents < ActiveRecord::Migration
  def change
    create_table :events do |t|
      t.string :name
      t.text :description
      t.integer :community_user_id
      t.string :type
      t.boolean :deleted, default: false, nil: false
      t.boolean :active, default: true, nil: true

      t.timestamps
    end
  end
end
