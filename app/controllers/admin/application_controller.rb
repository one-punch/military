class Admin::ApplicationController < ActionController::Base
  include ApplicationHelper
  protect_from_forgery with: :exception
  layout 'admin'

  before_filter :require_login

  def home
    render "admin/home/index"
  end

  def require_login
    return true if current_user.present?
    if cookies.signed[:user].present?
      _params = cookies.signed[:user].split("-")
      if _params.size > 1
        _id = _params[0]
        _username = _params[1]
        @user = User.where(id: _id, username: _username).last
        if @user.present?
          session[:user_id] = @user.id
        end
      end
    else
      if request.get?
        redirect_to(admin_login_url({to: encode64(request.fullpath) })) and return
      end
      redirect_to(admin_login_url) and return
    end
  end

end