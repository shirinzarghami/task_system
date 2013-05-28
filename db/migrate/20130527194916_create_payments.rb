class CreatePayments < ActiveRecord::Migration
  def change
    create_table :payments do |t|
      t.string :title
      t.integer :community_user_id
      t.datetime :date
      t.text :description
      t.text :dynamic_attributes
      t.string :type
      t.decimal :price, :precision => 8, :scale => 2

      t.timestamps
    end
  end
end
