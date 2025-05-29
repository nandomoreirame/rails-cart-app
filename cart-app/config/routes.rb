Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Defines the root path route ("/")
  # root "posts#index"

  get "cart", to: "cart#list_items"
  # post "cart", to: "cart#add_item"
  post "cart/add_item", to: "cart#add_item"
  delete "cart/:product_id", to: "cart#remove_item"
end
