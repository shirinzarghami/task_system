class ChangePaymentDateToTime < ActiveRecord::Migration
  def up
    change_column :payments, :date, :datetime
    rename_column :payments, :date, :payed_at
  end

  def down
    rename_column :payments, :payed_at, :date
    change_column :payments, :date, :date
  end
end
