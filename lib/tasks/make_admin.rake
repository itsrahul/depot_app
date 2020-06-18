desc "Assign admin to role user"
task :make_admin, [:user_email] => :environment do |task, args|
  email = args.user_email
  user = User.find_by(email: email)
  user.role = 'admin'
  user.save
end