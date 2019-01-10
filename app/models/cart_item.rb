class CartItem < ApplicationRecord
  # Relationships
  belongs_to :cart
  belongs_to :product

  # Decreases inventory of products by self.qty
  # @return [Product]
  def decrease_inventory
    product.decrease_inventory(qty)
  end
end
