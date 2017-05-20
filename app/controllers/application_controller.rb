class ApplicationController < ActionController::Base
  include ApplicationHelper
  protect_from_forgery with: :exception

  before_filter :require_login, only: [:home]

  def home
    render "home/index"
  end

  def require_login
    return true if current_customer.present?
    if cookies.signed[:customer].present?
      _params = cookies.signed[:customer].split("-")
      if _params.size > 1
        _id = _params[0]
        _email = _params[1]
        @customer = Customer.where(id: _id, email: _email).last
        if @customer.present?
          session[:customer_id] = @customer.id
        end
      end
    else
      if request.get?
        redirect_to(login_url({to: encode64(request.fullpath) })) and return
      end
      redirect_to(login_url) and return
    end
  end

end
