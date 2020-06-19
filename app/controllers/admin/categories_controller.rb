class Admin::CategoriesController < AdminBaseController
  def index
    @categories = Category.includes(:sub_categories)
  end

  def show
    # @category = Category.find(params[:id])
    # @products = @category.products
    # @products += @category.sub_category_products.map(&:products)[0] if @category.is_root?
    redirect_to category_products_path(params[:id])
  end
end
