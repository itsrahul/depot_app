class AdminController < ApplicationController
  before_action :ensure_user_is_admin, except: :index
  def index
    @total_orders = Order.count
    @categories = Category.includes(:sub_categories)
  end
  def ensure_user_is_admin
    unless current_user.role == 'admin'
      redirect_to store_index_url, notice: "You don't have privilege to access this section"
    end
  end
end
