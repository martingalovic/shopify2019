class CartObserver < ActiveRecord::Observer
  def after_save(cart)
    cart.update_inventory if cart.is_completed?
  end
end