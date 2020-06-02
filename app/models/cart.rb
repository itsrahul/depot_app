class Cart < ApplicationRecord
  has_many :line_items, dependent: :destroy
  has_many :products, through: :line_items
  has_many :products_enabled, -> { where enabled: true }, through: :line_items, source: :product

  def add_product(product)
    current_item = line_items.find_by(product_id: product.id)
    if current_item
      current_item.quantity += 1
      current_item.product_price = product.price
    else
      current_item = line_items.build(product_id: product.id, product_price: product.price)
      self.line_items_count += 1
      self.save!
    end
    current_item
  end

  def total_price
    line_items.to_a.sum{ |item| item.total_price}
  end

end
