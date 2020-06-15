desc "Assign category to products without one"
task :port_legacy_products => :environment do
  first_category = Category.first.id
  Product.where(category_id: nil).each do |product|
    product.category_id = first_category
    product.save
  end
end