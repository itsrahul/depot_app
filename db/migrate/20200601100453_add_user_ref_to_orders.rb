class AddUserRefToOrders < ActiveRecord::Migration[6.0]
  def change
    add_reference :orders, :user, null: false, foreign_key: true, default: 2
  end
end
