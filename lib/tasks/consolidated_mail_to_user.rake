desc "Send user consolidated mail for all order places by him"
task :consolidated_mail, [:user_email] => :environment do |task, args|
  email = args.user_email
  user = User.find_by(email: email)
  OrderMailer.consolidated_mail(user).deliver_later
end