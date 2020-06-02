class LineItem < ApplicationRecord
  belongs_to :order, optional: true
  belongs_to :product, optional: true
  belongs_to :cart, counter_cache: true
  
  validates :product_id, uniqueness: { scope: :cart_id }

  def total_price
    product_price * quantity
  end
end
