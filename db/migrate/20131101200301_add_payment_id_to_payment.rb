class AddPaymentIdToPayment < ActiveRecord::Migration
  def change
    add_column :payments, :payment_id, :integer
  end
end
