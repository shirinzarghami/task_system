class AddTypeToUserSaldoModification < ActiveRecord::Migration
  def change
    add_column :user_saldo_modifications, :chargeable_type, :string
    rename_column :user_saldo_modifications, :payment_id, :chargeable_id
    UserSaldoModification.update_all chargeable_type: 'Payment'
  end
end
