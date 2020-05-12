class AddProductPriceToLineItems < ActiveRecord::Migration[6.0]
  def change
    add_column :line_items, :product_price, :integer
  end
end
