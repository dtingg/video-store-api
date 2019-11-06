Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  get "/zomg", to: "customers#zomg", as: "zomg"
  
  resources :customers, only: [:index]
end
