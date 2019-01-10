Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  namespace :api do
    namespace :v1 do
      #products
      resources :products, only: [:index, :show]

      # carts
      resources :carts, only: [:show, :create, :destroy]
      get 'carts/show', to: 'carts#show'
      match 'carts/complete', to: 'carts#complete', via: :post
      match 'carts', to: 'carts#destroy', via: :delete

      # cart items
      resources :cart_items, only: [:create, :destroy]
    end
  end
end
