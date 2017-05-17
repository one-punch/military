class Admin::ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  layout 'admin'

  def home
    render "admin/home/index"
  end

end