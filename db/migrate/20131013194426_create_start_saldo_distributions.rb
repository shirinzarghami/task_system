class CreateStartSaldoDistributions < ActiveRecord::Migration
  def change
    create_table :start_saldo_distributions do |t|
      t.integer :community_id

      t.timestamps
    end
  end
end
