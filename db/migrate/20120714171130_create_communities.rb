class CreateCommunities < ActiveRecord::Migration
  def change
    create_table :communities do |t|
      t.string :name
      t.string :subdomain

      t.timestamps
    end
    # Create join table
    create_table :communities_users do |t|
      t.integer :community_id
      t.integer :user_id
      t.string :role

      t.timestamps
    end
  end
end
