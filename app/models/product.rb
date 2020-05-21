class UrlValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    unless value =~ /\.(gif|jpg|png)\z/i
      record.errors[attribute] << (options[:message] || "must be a URL for GIF, JPG or PNG image.")
    end
  end
end

class Product < ApplicationRecord
  has_many :line_items
  has_many :orders, through: :line_items

  before_destroy :ensure_not_referenced_by_any_line_item

  validates :title, :description, :image_url, presence: true
  validates :title, uniqueness: true
  validates :image_url, allow_blank: true, url: true
  #  format: {
  #   with:    %r{\.(gif|jpg|png)\z}i,
  #   message: 'must be a URL for GIF, JPG or PNG image.'
  # }
  validates :title, length: {minimum: 10}
  validates :words_in_description, length: { minimum: 5, maximum: 10}
  validates :price, :discount_price, allow_blank: true, numericality: { greater_than_or_equal_to: 0.01 }
  validates :price, numericality: { greater_than_or_equal_to: :discount_price}

  validates :permalink, uniqueness: :true, format: { with: /\A[a-zA-Z0-9\-]+\z/ }
  validates :words_in_permalink, length: { minimum: 3} 

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
end
