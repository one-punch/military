class Admin::SessionController < Admin::ApplicationController

  skip_filter :require_login, only: [:login]

  def login
    redirect_to(admin_url) and return if current_user.present?
    if request.post?
      respond_to do |format|
        if params[:username].present? && params[:password].present?
          @user = User.where(username: params[:username].strip).last
          if @user.blank?
            format.js{ render "/admin/session/fail", locals: {message: "Username not exist"} }
          elsif @user.verify_password(params[:password].strip)
            session[:user_id] = @user.id
            if params[:remember].present?
              cookies.signed[:user] = "#{@user.id}-#{@user.username}"
            else
              cookies.delete(:user)
            end
            if params[:to].present?
              @to = decode64(params[:to])
            end
            format.js{ render "/admin/session/success", locals: {message: "Login Success"} }
          else
            format.js{ render "/admin/session/fail", locals: {message: "Password not correct"} }
          end
        else
          format.js{ render "/admin/session/fail", locals: {message: "Please Input Email and Password to Login"} }
        end
      end
    else
      render layout: "login"
    end
  end


  def sign_out
    clear_current_user
    redirect_to(admin_url) and return
  end

end
