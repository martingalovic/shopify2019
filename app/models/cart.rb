class Cart < ApplicationRecord
  has_many :items, class_name: "CartItem"

  # Checks whether cart is completed
  # @return [Boolean]
  def is_completed?
    !completed_at.nil?
  end

  # @param [nil|Time] at When was the cart completed, default: Time.now
  # @return [self]
  def complete(at = nil)
    update(completed_at: at || Time.now)
  end

  def update_inventory
    cart_items.each do |item|
      item.product.decrease_inventory
    end
  end

end
