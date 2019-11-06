Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  get "/zomg", to: "customers#zomg", as: "zomg"
  
  resources :customers, only: [:index]
  resources :movies, only: [:index, :show, :create]
  
  get "/rentals/check-out", to: "rentals#check_out", as: "check_out"
  get "/rentals/check-in", to: "rentals#check_in", as: "check_in"
end
