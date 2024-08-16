Rails.application.routes.draw do
  scope "(:locale)", locale: /en|vi/ do
    root "homes#index"
    
    get "/login", to: "sessions#new"
    post "/login", to: "sessions#create"
    delete "/logout", to: "sessions#destroy"

    resources :users
    resources :products
    resources :cart_items, only: %i(create)

  end
end
