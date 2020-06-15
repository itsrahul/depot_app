class Address < ApplicationRecord
  validates :user_id, uniqueness: true
  belongs_to :user, optional: true
end
