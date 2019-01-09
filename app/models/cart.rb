class Cart < ApplicationRecord
  has_many :items, class_name: "CartItem"

  # Adds product to cart
  # @param [Product] product
  # @return [CartItem] created or updated CartItem
  def add_product(product, qty = 1)
    return false unless product.is_a?(Product)

    item = items.where(:product_id => product.id).first_or_create
    item.increment!(:qty, qty)
  end

  # Checks whether cart is completed
  # @return [Boolean]
  def is_completed?
    !completed_at.nil?
  end

  # Marks cart as completed
  # @param [nil|Time] at - When was the cart completed, default: Time.now
  # @return [self]
  def complete(at = nil)
    update(completed_at: at || Time.now)
  end

  # Updates inventory of each product in cart
  # @return [self]
  def update_inventory
    cart_items.each(&:decrease_inventory)
    self
  end

end
