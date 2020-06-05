class LineItem < ApplicationRecord
  belongs_to :order, optional: true
  belongs_to :product, optional: true
  belongs_to :cart, counter_cache: true
  
  validates :product, uniqueness: { scope: :cart }

  def total_price
    product_price * quantity
  end
end
