class Admin::ReportsController < ApplicationController
  # before_action :ensure_user_is_admin

  def index
    @from = params[:from].blank? ? nil : params[:from]
    @to = params[:to].blank? ? nil : params[:to]
    @orders = Order.by_date(@from, @to)
    # request.path
    # @orders = Order.by_date(Time.current.beginning_of_day-31.day)
  end


  # protected
  # def filter_params
  #   params.require(:filter).permit(:from, :to)
  # end
    # def ensure_user_is_admin
    #   unless current_user.role == 'admin'
    #     redirect_to store_index_url, notice: "You don't have privilege to access this section"
    #   end
    # end
end
