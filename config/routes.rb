Rails.application.routes.draw do
  devise_for :users
  resources :stores
  scope :buyers do
    resources :orders, only: [:index, :create, :update, :destroy]
  end

  post "new" => "registrations#create", as: :create_registration

  get "me" => "registrations#me"

  post "sign_in" => "registrations#sign_in"

  get "listing" => "products#listing"

  root to: "welcome#index"

  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Defines the root path route ("/")
  # root "posts#index"
end
