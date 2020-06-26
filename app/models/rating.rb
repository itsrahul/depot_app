class Rating < ApplicationRecord
  belongs_to :product
  validates :user_id, uniqueness: { scope: :product }
  validates :value, numericality: {greater_than_or_equal_to: 0, less_than_or_equal_to: 5}
end
