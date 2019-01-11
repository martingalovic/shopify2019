class CartItem < ApplicationRecord
  # Relationships
  belongs_to :cart
  belongs_to :product

  # Decreases inventory of products by 1
  # @return [Product]
  def decrease_inventory
    product.decrease_inventory
  end

  # Use this method if you want to prevent deleting the item in case cart was already completed
  def remove_from_cart
    raise Error::Cart::AlreadyCompletedError if cart.is_completed?

    destroy
  end
end
