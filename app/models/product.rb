class Product < ApplicationRecord
  has_many :line_items, dependent: :restrict_with_error
  has_many :orders, through: :line_items
  has_many :carts, through: :line_items

  scope :enabled, -> {where(:enabled => true)}

  scope :get_product_in_atleast_one_line_item, -> {
    joins(:line_items).distinct
  }
  
  scope :get_title_for_product_in_atleast_one_line_item, -> {
    get_product_in_atleast_one_line_item.pluck(:title)
  }
  # before_destroy :ensure_not_referenced_by_any_line_item

  validates :title, :description, :image_url, presence: true
  validates :title, uniqueness: true
  validates :image_url, allow_blank: true, image_url: true

  validates :title, length: {minimum: 10}
  validates :words_in_description, length: { minimum: 5, maximum: 10}
  validates :price, allow_blank: true, numericality: { greater_than_or_equal_to: 0.01 }
  validates :discount_price, allow_blank: true, numericality: { less_than_or_equal_to: :price}

  validates :permalink, uniqueness: :true, format: { with: /\A[a-zA-Z0-9\-]+\z/ }
  validates :words_in_permalink, length: { minimum: 3} 

  after_initialize :set_title, :set_discount_price
  private

    # ensure that there are no line items referencing this product
    def ensure_not_referenced_by_any_line_item
      unless line_items.empty?
        errors.add(:base, 'Line Items present')
        throw :abort
      end
    end

    def words_in_permalink
      permalink.split('-')
    end
  
    def words_in_description
      description.scan(/\w+/)
    end

    def set_title
      self.title = 'abc' if title.blank?
    end

    def set_discount_price
      self.discount_price = self.price if discount_price.blank?
    end
end
