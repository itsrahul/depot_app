class Admin::CategoriesController < ApplicationController
  # before_action :ensure_user_is_admin
  def index
    @categories = Category.includes(:sub_categories)
  end
  # def ensure_user_is_admin
  #   unless current_user.role == 'admin'
  #     redirect_to store_index_url, notice: "You don't have privilege to access this section"
  #   end
  # end
end
