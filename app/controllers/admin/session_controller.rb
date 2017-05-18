class Admin::SessionController < Admin::ApplicationController

  def login
    render layout: "login"
  end

end
