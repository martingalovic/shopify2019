require 'test_helper'

class Api::V1::CartItemsControllerTest < ActionDispatch::IntegrationTest
  test "cart items controller should create with valid product and uncompleted unassigned cart for guest" do
    post api_v1_cart_items_url, params: {cart_token: guest_cart_uncompleted.token, product_id: product.id }
    assert_response :success
  end

  test "cart items controller should not create with valid product and completed unassigned cart for guest" do
    post api_v1_cart_items_url, params: { cart_token: guest_cart_completed.token, product_id: product.id }
    assert_response 422
  end

  test "cart items controller should not create with valid product and uncompleted assigned cart for guest" do
    post api_v1_cart_items_url, params: {cart_token: user_cart_uncompleted.token, product_id: product.id }
    assert_response 401
  end

  test "cart items controller should not create with valid product and completed assigned cart for guest" do
    post api_v1_cart_items_url, params: { cart_token: user_cart_completed.token, product_id: product.id }
    assert_response 401
  end

  test "cart items controller should not create with product out of stock for guest" do
    post api_v1_cart_items_url, params: {cart_token: guest_cart_uncompleted.token, product_id: product_out_of_stock.id }
    assert_response 422
  end

  test "cart items controller should not create with product out of stock for logged in user" do
    post api_v1_cart_items_url, params: {cart_token: user_cart_uncompleted.token, product_id: product_out_of_stock.id }, headers: authenticated_header
    assert_response 422
  end

  test "cart items controller should not create for assigned cart for guest" do
    post api_v1_cart_items_url, params: {cart_token: user_cart_uncompleted.token, product_id: product.id }
    assert_response 401
  end

  test "cart items controller should not create for assigned cart for wrong logged in user" do
    post api_v1_cart_items_url, params: {cart_token: user_cart_uncompleted.token, product_id: product.id }, headers: authenticated_header(:two)
    assert_response 401
  end


  test "cart items controller should destroy from uncompleted unassigned cart for guest" do
    delete api_v1_cart_item_url(cart_item_guest_uncompleted), params: { cart_token: cart_item_guest_uncompleted.cart.token }
    assert_response :success
  end

  test "cart items controller should not destroy from completed unassigned cart for guest" do
    delete api_v1_cart_item_url(cart_item_guest_completed), params: { cart_token: cart_item_guest_completed.cart.token }
    assert_response 422
  end

  test "cart items controller should destroy from uncompleted assigned cart for logged in user" do
    delete api_v1_cart_item_url(cart_item_user_uncompleted), params: { cart_token: cart_item_user_uncompleted.cart.token }, headers: authenticated_header
    assert_response :success
  end

  test "cart items controller should not destroy from completed assigned cart for logged in user" do
    delete api_v1_cart_item_url(cart_item_guest_completed), params: { cart_token: cart_item_guest_completed.cart.token }, headers: authenticated_header
    assert_response 422
  end

  test "cart items controller should not destroy from assigned cart for guest" do
    delete api_v1_cart_item_url(cart_item_user_uncompleted), params: { cart_token: cart_item_user_uncompleted.cart.token }
    assert_response 401
  end

  test "cart items controller should not destroy from assigned cart for wrong logged in user" do
    delete api_v1_cart_item_url(cart_item_user_uncompleted), params: { cart_token: cart_item_user_uncompleted.cart.token }, headers: authenticated_header(:two)
    assert_response 401
  end

  private
    def cart_item_guest_uncompleted
      cart_items(:guest_uncompleted)
    end

    def cart_item_guest_completed
      cart_items(:guest_completed)
    end

    def cart_item_user_uncompleted
      cart_items(:user_uncompleted)
    end

    def cart_item_user_completed
      cart_items(:user_completed)
    end

    def guest_cart_uncompleted
      carts(:one)
    end

    def guest_cart_completed
      carts(:two)
    end

    def user_cart_uncompleted
      carts(:three)
    end

    def user_cart_completed
      carts(:four)
    end

    def product
      products(:one)
    end

    def product_out_of_stock
      products(:out_of_stock)
    end

    def invalid_product
      products(:not_existent)
    end

    def authenticated_header(key = :one)
      token = Knock::AuthToken.new(payload: { sub: users(key).id }).token

      {
          'Authorization': "Bearer #{token}"
      }
    end

end
