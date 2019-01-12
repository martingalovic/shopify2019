require 'test_helper'

class CartItemTest < ActiveSupport::TestCase
  test "cart item model method decrease_inventory should decrease product inventory_count" do
    item = item_for_uncompleted_cart
    initial_stock = item.product.inventory_count
    item.decrease_inventory
    new_stock = item.product.inventory_count

    assert_equal initial_stock - 1, new_stock
  end

  test "cart item model method remove_from_cart should raise error if cart is already completed" do
    assert_raise(Error::Cart::AlreadyCompletedError) do
      item_for_completed_cart.remove_from_cart
    end
  end

  test "cart item model method remove_from_cart should return true if cart is not completed" do
    item_for_uncompleted_cart.remove_from_cart
    assert true
  end

  private
    def item_for_uncompleted_cart
      cart_items(:test_item_for_uncompleted_with_item_one)
    end

    def item_for_completed_cart
      cart_items(:guest_completed)
    end
end
