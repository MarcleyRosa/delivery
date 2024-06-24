Rails.application.routes.draw do
  devise_for :users
  resources :stores do
    resources :products, only: [:index]
    get "/orders/new" => "stores#new_order"
  end
  scope :buyers do
    resources :orders, only: [:index, :create, :update, :destroy]
  end

  resource :cart, only: [:show, :destroy] do
    post 'add_item', to: 'carts#add_item'
    delete 'remove_item/:product_id', to: 'carts#remove_item', as: 'remove_item'
  end

  resources :products

  post "new" => "registrations#create", as: :create_registration

  get 'store/:id/orders', to: 'stores#store_orders'

  get 'order/:id', to: 'orders#order_items'

  get 'search' => 'products#search'

  get 'state/order/:id', to: 'orders#order_state'

  get "me" => "registrations#me"

  get "profile" => "registrations#profile"

  delete "profile/:id" => "registrations#destroy"

  post "sign_in" => "registrations#sign_in"

  get "listing" => "products#listing"

  post "products/linsting" => "products#products_listing"

  get "store/:id/products" => "products#products_store"

  root to: "welcome#index"

  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Defines the root path route ("/")
  # root "posts#index"
end
