Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  get "/" => "application#home"

  get "/login" => "session#login"
  get "/register" => "session#register"

  namespace "admin" do
    get "/" => "application#home"
    get "/login" => "session#login"
  end

end
