class Admin::CategoriesController < AdminBaseController
  def index
    @categories = Category.includes(:sub_categories)
  end
end
