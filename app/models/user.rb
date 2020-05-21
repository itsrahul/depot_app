class User < ApplicationRecord
  validates :name, presence: true, uniqueness: true
  has_secure_password

  after_destroy :ensure_an_admin_remains

  validates :email, uniqueness: true
  validates :email, format: { with: /\A\w{3,}@\w{3,}[.][a-zA-Z]{2,}\z/i }

  class Error < StandardError
  end

  private
    def ensure_an_admin_remains
      if User.count.zero?
        raise Error.new "Can't delete last user"
      end
    end  
end
