class CartItem < ApplicationRecord
  # Relationships
  belongs_to :cart
  belongs_to :product

  # Decreases inventory of products by 1
  # @return [Product]
  def decrease_inventory
    product.decrease_inventory
  end
end
