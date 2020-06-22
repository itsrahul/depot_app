class Admin::ReportsController < AdminBaseController

  def index
    @from = params[:from].blank? ? nil : params[:from]
    @to = params[:to].blank? ? nil : params[:to]
    @orders = Order.by_date(@from, @to)
    # @orders = Order.by_date(Time.current.beginning_of_day-31.day)
  end


  # protected
  # def filter_params
  #   params.require(:filter).permit(:from, :to)
  # end
end
