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

  def clear_current_user
    @user = nil if @user.present?
    session.delete(:user_id) if session[:user_id].present?
  end

  def clear_current_customer
    @customer = nil if @customer.present?
    session.delete(:customer_id) if session[:customer_id].present?
  end

  def encode64(str)
    Base64.encode64(str).strip
  end

  def decode64(str)
    Base64.decode64(str.strip)
  end

end
