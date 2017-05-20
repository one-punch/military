require "validator/email_validator"

class Customer < ApplicationRecord
  include Profile
  validates :email, presence: true, uniqueness: true, email: true

end
