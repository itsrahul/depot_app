class User < ApplicationRecord
  validates :name, presence: true, uniqueness: true
  has_secure_password

  after_create_commit :welcome_email
  before_update :unable_to_update_admin
  before_destroy :unable_to_delete_admin
  after_destroy :ensure_an_admin_remains

  validates :email, uniqueness: { case_sensitive: false }, email: true

  class Error < StandardError
  end

  private
    def ensure_an_admin_remains
      if User.count.zero?
        raise Error.new "Can't delete last user"
      end
    end  
    
    def welcome_email
      OrderMailer.new_user(self).deliver_later
    end
        
    def unable_to_update_admin
      if self.email_was == 'admin@depot.com'
        raise Error.new "Can't update last user"
      end
    end

    def unable_to_delete_admin
      if self.email == 'admin@depot.com'
        raise Error.new "Can't delete last user"
      end
    end
end
