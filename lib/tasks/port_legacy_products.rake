desc "This task assign the first category to all products already created"
# task port_legacy_products: [:arg_1] => [:prerequisite_1, :prerequisite_2] do |task, args|
task :port_legacy_products do
  @products = Product.all
  debugger
  # Seriously, nothing
end