Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  get "/" => "application#home"


  namespace "admin" do
    get "/" => "application#home"
  end

end
