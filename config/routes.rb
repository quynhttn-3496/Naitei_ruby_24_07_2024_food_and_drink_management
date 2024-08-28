Rails.application.routes.draw do
  scope "(:locale)", locale: /en|vi/ do
    scope module: "user" do
      resources :orders, only: [:index] 
    end    
    namespace :admin do
      resources :orders, only: [:index, :destroy] 
    end

    root "products#index"
    
    get "/login", to: "sessions#new"
    post "/login", to: "sessions#create"
    delete "/logout", to: "sessions#destroy"

    resources :users
    resources :products

    resources :cart_items
    resource :carts
  end
end
