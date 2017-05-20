require 'active_support/concern'
require 'securerandom'

module Profile
  extend ActiveSupport::Concern

  def self.included(base)

    base.class_eval do
      before_create :verify

      attr_accessor :password, :password_confirmation
    end

    def generate_unit_hex
      self.class.generate_unit_hex
    end

    def reset_password!(pwd)
      raise Military::Error::Base.new("Password could not be nil") and return if pwd.blank?
      raise Military::Error::Base.new("Passwords must be between 6-16 characters long") and return if pwd.length < 6 || pwd.length > 16
      @password = pwd
      self[:password_hash] = encrypt(pwd)
      self.save!
    end

    def reset_password(pwd)
      begin
        reset_password!(pwd)
        true
      rescue Military::Error::Base => e
        false
      end
    end

    def verify
      if password.blank?
        errors.add(:password, :invalid, message: "Password could not be nil")
        throw(:abort) and return
      elsif password_confirmation.blank?
        errors.add(:password_confirmation, :invalid, message: "Password Confirmation could not be nil")
        throw(:abort) and return
      elsif password_confirmation != password
        errors.add(:password_confirmation, :invalid, message: "Password Confirmation mismatch Password")
        throw(:abort) and return
      elsif password.length >= 6 && password.length <= 16
        self[:salt] = generate_unit_hex
        self[:password_hash] = encrypt(password)
      else
        errors.add(:password, :invalid, message: "Passwords must be between 6-16 characters long")
        throw(:abort) and return
      end
    end

    def verify_password(pwd)
      encrypt(pwd) == self.password_hash
    end

    def encrypt(str)
      Digest::SHA2.hexdigest("#{self.salt}#{str}")
    end

  end

  class_methods do
    def generate_unit_hex
      SecureRandom.hex(8)
    end
  end
end