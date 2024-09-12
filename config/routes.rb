Rails.application.routes.draw do
  devise_for :users, only: :omniauth_callbacks, controllers: { omniauth_callbacks: "omniauth_callbacks" }
  scope "(:locale)", locale: /en|vi/ do   
    root "products#index"
  
    devise_for :users,  skip: :omniauth_callbacks do
      get "signin" => "devise/sessions#new"
      post "signin" => "devise/sessions#create"
      delete "signout" => "devise/sessions#destroy"
    end

    resources :products
    resources :cart_items
    resource :carts
    resources :orders

    namespace :admin do
      root to: "dashboard#index"
      get "dashboard", to: "dashboard#index"
      resources :orders, only: %i(index update)
      resources :products
    end
  end
end
