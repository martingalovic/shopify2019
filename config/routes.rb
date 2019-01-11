Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  namespace :api do
    namespace :v1 do
      post 'login' => 'user_token#create'

      #products
      resources :products, only: [:index, :show]

      # carts
      resources :carts, only: [:show, :create, :destroy]
      match 'carts/complete', to: 'carts#complete', via: :post

      # cart items
      resources :cart_items, only: [:create, :destroy]
    end
  end
end
