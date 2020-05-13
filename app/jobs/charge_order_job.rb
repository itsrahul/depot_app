class ChargeOrderJob < ApplicationJob
  queue_as :default

  def perform(order, pay_order_params)
    order.charge!(pay_order_params)
  end
end
