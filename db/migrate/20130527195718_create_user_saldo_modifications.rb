class CreateUserSaldoModifications < ActiveRecord::Migration
  def change
    create_table :user_saldo_modifications do |t|
      t.decimal :price, :precision => 8, :scale => 2
      t.integer :payment_id
      t.integer :community_user_id
      t.decimal :percentage, :precision => 8, :scale => 2
      # t.decimal :percentage, :precision => 2, :scale => 2
      t.boolean :checked
      t.timestamps
    end
  end
end
