class OrderMailer < ApplicationMailer
  default from: 'Rahul <depot@example.com>'
  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.order_mailer.received.subject
  #
  def received
    @order = order

    mail to: order.email, subject: 'Pragmatic Store Order Confirmation'
  end

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.order_mailer.shipped.subject
  #
  def shipped
    @order = order

    mail to: order.email, subject: 'Pragmatic Store Order Shipped'
  end

  def new_user(user)
    @user = user
    mail to: user.email, subject: 'Welcome'
  end
end
