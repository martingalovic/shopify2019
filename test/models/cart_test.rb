require 'test_helper'

class CartTest < ActiveSupport::TestCase
  # Find by token and user
  #
  test "cart model method find_by_user_and_token should return unassigned cart for guest" do
    c = Cart.find_by_token_and_user(guest_cart.token, guest)
    assert_instance_of Cart, c
  end

  test "cart model method find_by_user_and_token should return unassigned cart for logged in user" do
    c = Cart.find_by_token_and_user(guest_cart.token, logged_in_user)
    assert_instance_of Cart, c
  end

  test "cart model method find_by_user_and_token should return assigned cart for logged in user" do
    c = Cart.find_by_token_and_user(user_cart.token, logged_in_user)
    assert_instance_of Cart, c
  end

  test "cart model method find_by_user_and_token should not return assigned cart for guest" do
    assert_raise(Error::UnauthorizedError) do
      Cart.find_by_token_and_user(user_cart.token, guest)
    end
  end

  test "cart model method find_by_user_and_token should not return assigned cart for wrong user" do
    assert_raise(Error::UnauthorizedError) do
      Cart.find_by_token_and_user(user_cart.token, wrong_user)
    end
  end

  # Add product
  #
  test "cart model method add_product should add product to uncompleted cart items if product is valid" do
    item = uncompleted_cart.add_product valid_product
    assert_instance_of CartItem, item
  end

  test "cart model method add_product should raise already completed error if cart is completed" do
    assert_raise(Error::Cart::AlreadyCompletedError) do
      completed_cart.add_product valid_product
    end
  end

  test "cart model method add_product should raise product type error if invalid product is provided" do
    assert_raise(Error::CartItem::ProductTypeError) do
      uncompleted_cart.add_product invalid_product
    end
  end

  test "cart model method add_product should raise out of stock error if invalid product is out of stock" do
    assert_raise(Error::Product::OutOfStockError) do
      uncompleted_cart.add_product out_of_stock_product
    end
  end

  # Complete
  #
  test "cart model method complete should set completed_at and total column if cart is valid" do
    c = uncompleted_cart_with_items
    c.complete

    assert_not_nil c.completed_at
    assert_not_nil c.total
  end

  test "cart model method complete should raise already completed error if cart is already completed" do
    assert_raise(Error::Cart::AlreadyCompletedError) do
      c = completed_cart
      c.complete
    end
  end

  test "cart model method complete should raise empty cart error if cart is empty" do
    assert_raise(Error::Cart::EmptyCartError) do
      c = uncompleted_cart_with_no_items
      c.complete
    end
  end

  # Calculate total
  #
  test "cart model method calculate_total should match products price" do
    cart = uncompleted_cart_with_items

    calculated_manual = 0.to_f
    cart.items.each { |item| calculated_manual += item.product.price.to_f }

    assert_equal calculated_manual, cart.calculate_total
  end

  # Destroy
  #
  test "cart model destroy should destroy if cart is uncompleted" do
    uncompleted_cart.destroy!
    assert true
  end

  test "cart model destroy should raise error if cart is already completed" do
    assert_raise(Error::Cart::AlreadyCompletedError) do
      completed_cart.destroy!
    end
  end

  private
    def guest
      nil
    end

    def logged_in_user
      users(:one)
    end

    def wrong_user
      users(:two)
    end

    def user_cart
      logged_in_user.carts.first
    end

    def completed_cart
      carts(:completed)
    end


    def uncompleted_cart
      c = carts(:uncompleted)
      c.token = "X"*Cart::TOKEN_LENGTH # To prevent validation error
      c
    end

    def uncompleted_cart_with_no_items
      c = uncompleted_cart
      c.items.delete_all
      c
    end


    def uncompleted_cart_with_items
      c = carts(:uncompleted_with_items)
      c.token = "X"*Cart::TOKEN_LENGTH # To prevent validation error
      c
    end

    def guest_cart
      carts(:one)
    end

    def valid_product
      products(:one)
    end

    def invalid_product
      nil
    end

    def out_of_stock_product
      products(:out_of_stock)
    end
end
