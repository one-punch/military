require "base64"

module ApplicationHelper

  def current_customer
    if @customer.present?
      @customer
    elsif session[:customer_id].present? && Customer.where(id: session[:customer_id]).exists?
      @customer = Customer.where(id: session[:customer_id]).last
    end
  end

  def current_user
    if @user.present?
      @user
    elsif session[:user_id].present? && User.where(id: session[:user_id]).exists?
      @user = User.where(id: session[:user_id]).last
    end
  end

  def encode64(str)
    Base64.encode64(str).strip
  end

  def decode64(str)
    Base64.decode64(str.strip)
  end

end
