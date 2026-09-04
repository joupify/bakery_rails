Rails.application.routes.draw do
  devise_for :users
  resource :cart, only: [:show] do
    post "add/:product_id", to: "carts#add_product", as: :add_product
    delete "remove/:product_id", to: "carts#remove_item", as: :remove_item
    patch "quantity/:product_id", to: "carts#update_quantity", as: :update_quantity
  end
  resources :reservations, only: [:new, :create, :show] do
    member do
      get :checkout
    end
  end
  post "/stripe/webhook", to: "stripe_webhooks#create"
  get "/products", to: "product#index", as: :products
  get "product/index"
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Render dynamic PWA files from app/views/pwa/*
  get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker
  get "manifest" => "rails/pwa#manifest", as: :pwa_manifest

  # Defines the root path route ("/")
   root "product#index"
end
