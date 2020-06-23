class OrderMailer < ApplicationMailer
  default from: 'Rahul <depot@example.com>'
  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.order_mailer.received.subject
  #
  def received(id)
    @order = Order.find(id)
    @order.line_items.each do |line_item|
      line_item.product.product_images[1,2].each.with_index do |product_image, index| 
        attachments["#{line_item.product.title}_#{index+1}"] = product_image
      end
    end
    headers['X-SYSTEM-PROCESS-ID'] = Process.pid

    I18n.with_locale(@order.user.language) do
      mail to: @order.email, subject: t('.subject')
    end
  end

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.order_mailer.shipped.subject
  #
  def shipped(id)
    @order = Order.find(id)

    mail to: @order.email, subject: t('.subject')
  end

  def new_user(user)
    @user = user
    mail to: @user.email, subject: t('.subject')
  end

  def consolidated_mail(id)
    @user = User.find(id)
    
    mail to: @user.email, subject: t('.subject')
  end
end
