class Product < ApplicationRecord
  has_many :line_items, dependent: :restrict_with_error
  has_many :orders, through: :line_items
  has_many :carts, through: :line_items
  has_many :ratings, dependent: :destroy
  belongs_to :category, optional: true
  has_many_attached :product_images

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
  # validates :image_url, allow_blank: true, image_url: true

  validates :title, length: {minimum: 10}
  validates :words_in_description, length: { minimum: 5, maximum: 10}
  validates :price, allow_blank: true, numericality: { greater_than_or_equal_to: 0.01 }
  validates :discount_price, allow_blank: true, numericality: { less_than_or_equal_to: :price}

  validates :permalink, uniqueness: :true, format: { with: /\A[a-zA-Z0-9\-]+\z/ }
  validates :words_in_permalink, length: { minimum: 3} 
  validates :category_id, presence: true
  validates :product_images_size, length:{ minimum: 1, maximum: 3}

  after_initialize :set_title, :set_discount_price
  after_commit :set_parent_products_count, on: [:create, :destroy]
  after_update :update_parent_products_count, unless: Proc.new { |a| a.previous_changes[:category_id].nil?}

  def avg_rating
    ratings.average(:value)
  end

  private

  def set_parent_products_count
    Category.transaction do
      category.refresh_products_count!
      category.parent.refresh_products_count! unless category.is_root?
    end
  end

  def update_parent_products_count
    old_category, new_category = Category.find(previous_changes[:category_id])
    
    Category.transaction do
      old_category.refresh_products_count!
      old_category.parent.refresh_products_count! unless old_category.is_root?

      new_category.refresh_products_count!
      new_category.parent.refresh_products_count! unless new_category.is_root?
    end
  end

    # ensure that there are no line items referencing this product
    def ensure_not_referenced_by_any_line_item
      unless line_items.empty?
        errors.add(:base, 'Line Items present')
        throw :abort
      end
    end

    def product_images_size
      # debugger
      product_images
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
