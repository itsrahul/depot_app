class Category < ApplicationRecord
  validates :name, presence: true
  # validates :name, uniqueness: { conditions: -> { where("parent_id is NULL")} }, allow_blank: true
  validates :name, uniqueness: { scope: :parent_id, case_sensitive: false }, allow_blank: true

  validates :parent_id, valid_parent_id: true, unless:  Proc.new { |a| a.parent_id.nil? }
  # validates :parent_id, allow_blank: true, 
  # inclusion: { in: where("parent_id is null").pluck(:id), message: "%{value} is not a valid parent id" },
  # unless: Proc.new { |a| a.is_root? }
  
  has_many :products, dependent: :restrict_with_error
 
  has_many :sub_categories, class_name: "Category", foreign_key: "parent_id", dependent: :destroy
  belongs_to :parent, class_name: "Category", optional: true

  def sub_category_products
    sub_categories.map(&:products)[0].pluck(:id, :title)
  end

  def is_root?
    parent_id.nil?
  end

end
