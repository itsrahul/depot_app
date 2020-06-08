class Product < ApplicationRecord
  has_many :line_items, dependent: :restrict_with_error
  has_many :orders, through: :line_items
  has_many :carts, through: :line_items
  belongs_to :category

  scope :enabled, -> { where(enabled: true) }

  def self.atleast_in_one_line_item
    joins(:line_items).distinct
  end
  
  def self.get_title_for_atleast_in_one_line_item
    atleast_in_one_line_item.pluck(:title)
  end
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
  after_commit :set_parent_products_count, on: [:create, :destroy]
  before_update :update_parent_products_count

  private

  def set_parent_products_count
    category.products_count = category.products.count
    category.save
    unless category.is_root?
      parent_category = category.parent
      parent_category.products_count = parent_category.products.count + parent_category.sub_categories.sum(:products_count)
      parent_category.save
    end
  end

  def update_parent_products_count
    old_category = Category.find(category_id_was) #4
    if old_category.is_root?
      old_category.products_count = old_category.products.count + old_category.sub_categories.sum(:products_count) - 1
      old_category.save
    else
      old_category.products_count -= 1
      old_category.save
      
      old_parent_category = old_category.parent
      old_parent_category.products_count -= 1
      old_parent_category.save
    end
      category.reload.products_count += 1 
      category.save
      unless category.is_root?
        parent_category = category.parent #3
        parent_category.products_count += 1
        parent_category.save
      end
  end

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
