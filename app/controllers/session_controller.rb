class SessionController < ApplicationController

  def login
    redirect_to(home_url) and return if current_customer.present?
    if request.post?
      respond_to do |format|
        if params[:email].present? && params[:password].present?
          @customer = Customer.where(email: params[:email].strip).last
          if @customer.blank?
            format.js{ render "/session/fail", locals: {message: "Email not exist"} }
          elsif @customer.verify_password(params[:password].strip)
            session[:customer_id] = @customer.id
            if params[:remember].present?
              cookies.signed[:customer] = "#{@customer.id}-#{@customer.email}"
            else
              cookies.delete(:customer)
            end
            if params[:to].present?
              @to = decode64(params[:to])
            end
            format.js{ render "/session/success", locals: {message: "Login Success"} }
          else
            format.js{ render "/session/fail", locals: {message: "Password not correct"} }
          end
        else
          format.js{ render "/session/fail", locals: {message: "Please Input Email and Password to Login"} }
        end
      end
    end
  end

  def register
    redirect_to(home_url) and return if current_customer.present?
    if request.post?
      respond_to do |format|
        if params[:email].present? && params[:password].present? && params[:password_confirmation].present?
          if params[:password] != params[:password_confirmation]
            format.js{ render "/session/fail", locals: {message: "Password and Password Confirmation Mismatch"} }
          else
            @customer = Customer.new(email: params[:email].strip, password: params[:password].strip,
              password_confirmation: params[:password_confirmation].strip)
            if @customer.save
              session[:customer_id] = @customer.id
              if params[:to].present?
                @to = decode64(params[:to])
              end
              format.js{ render "/session/success", locals: {message: "Register Success"} }
            else
              format.js{ render "/session/fail", locals: {message: @customer.errors.full_messages.join("; ")} }
            end
          end
        else
          format.js{ render "/session/fail", locals: {message: "Please Input Email and Password to Register"} }
        end
      end
    end
  end

  def sign_out
    clear_current_customer
    redirect_to(home_url) and return
  end

end
