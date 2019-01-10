Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  namespace :api do
    namespace :v1 do
      resources :products, only: [:index, :show]
      resources :carts, only: [:show, :create, :update, :delete]
      resources :cart_items, only: [:create, :delete]
    end
  end
end
