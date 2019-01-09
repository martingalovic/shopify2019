class CartItem < ApplicationRecord
  belongs_to :cart
  belongs_to :product

  # Decreases inventory of product by self.qty
  # @return [Product]
  def decrease_inventory
    product.decrease_inventory(qty)
  end
end
