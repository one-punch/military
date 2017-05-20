class User < ApplicationRecord
  include Profile
  validates :username, presence: true, uniqueness: true

  def self.generate!(name)
    pwd = generate_unit_hex
    user = self.create!(username: name, password: pwd,
      password_confirmation: pwd)
    return {password: pwd, user: user}
  end

end
