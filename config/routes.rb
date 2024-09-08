Rails.application.routes.draw do
  scope "(:locale)", locale: /en|vi/ do   
    namespace :admin do
      resources :orders, only: %i(index update)
      resources :products
    end

    root "products#index"
    
    get "/login", to: "sessions#new"
    post "/login", to: "sessions#create"
    delete "/logout", to: "sessions#destroy"

    resources :users
    resources :products do
      resources :reviews
    end
    resources :cart_items
    resource :carts
    resources :orders
  end
end
