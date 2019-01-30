Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  namespace :api do
    namespace :v1 do
      if Rails.env.development?
        mount GraphiQL::Rails::Engine, at: "/graphiql", graphql_path: "/api/v1/graphql"
      end
      post "/graphql", to: "graphql#execute"

      # login
      post 'login' => 'user_token#create'

      #products
      resources :products, only: [:index, :show]

      # carts
      resources :carts, only: [:create]
      match 'carts/show', to: 'carts#show', via: :get
      match 'carts/complete', to: 'carts#complete', via: :post
      match 'carts/destroy', to: 'carts#destroy', via: :delete

      # cart items
      resources :cart_items, only: [:create, :destroy]
    end
  end
end