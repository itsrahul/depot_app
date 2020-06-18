class AdminController < ApplicationController
  def index
    @total_orders = Order.count
    @categories = Category.includes(:sub_categories)
  end
end
