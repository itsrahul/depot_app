# Preview all emails at http://localhost:3000/rails/mailers/order_mailer
class OrderMailerPreview < ActionMailer::Preview

  # Preview this email at http://localhost:3000/rails/mailers/order_mailer/received
  def received
    # OrderMailer.received(Order.find(15))
    # OrderMailer.received(Order.find(17))
    OrderMailer.received(Order.last)
  end

  # Preview this email at http://localhost:3000/rails/mailers/order_mailer/shipped
  def shipped
    OrderMailer.shipped
  end

  def consolidated_mail
    OrderMailer.consolidated_mail(User.find(2))
  end
end
