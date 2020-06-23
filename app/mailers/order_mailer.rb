class OrderMailer < ApplicationMailer
  default from: 'Rahul <depot@example.com>'
  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.order_mailer.received.subject
  #
  def received(order)
    @order = order
    @order.line_items.each do |line_item|
      line_item.product.product_images[1,2].each.with_index do |product_image, index| 
        attachments["#{line_item.product.title}_#{index+1}"] = product_image
      end
    end
    headers['X-SYSTEM-PROCESS-ID'] = Process.pid

    I18n.with_locale(@order.user.language) do
      mail to: order.email, subject: t('.subject')
    end
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

  def consolidated_mail(user)
    @user = user
    @orders = user.orders
    
    mail to: user.email, subject: 'Consolidated mail'
  end
end
