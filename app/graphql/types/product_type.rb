module Types
  class ProductType < BaseObject
    graphql_name "Product"
    description "a product"

    field :id, Int, null: false
    field :title, String, null: false
    field :price, Float, null: false
    field :inventory_count, Int, null: false
  end
end