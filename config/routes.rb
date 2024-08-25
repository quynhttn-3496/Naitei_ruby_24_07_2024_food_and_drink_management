Rails.application.routes.draw do
  scope "(:locale)", locale: /en|vi/ do
    root "homes#index"
    
    get "/login", to: "sessions#new"
    post "/login", to: "sessions#create"
    delete "/logout", to: "sessions#destroy"

    resources :users

    resources :cart_items
    resource :carts
    resource :orders

    resources :products do
      resources :reviews
    end

    namespace :admin do
      # root "homes#index"
      resources :products
    end
  end
end
