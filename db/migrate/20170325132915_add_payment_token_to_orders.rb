class AddPaymentTokenToOrders < ActiveRecord::Migration[5.0]
  def change
    add_column :orders, :payment_token, :string
  end
end
