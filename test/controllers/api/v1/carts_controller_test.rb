require 'test_helper'

class Api::V1::CartsControllerTest < ActionDispatch::IntegrationTest
  # Guest
  test "carts controller create should return new cart to guest" do
    post api_v1_carts_url
    assert_response :success
    assert_not_nil response_body['token']
  end

  test "carts controller show should return unassigned cart contents to guest" do
    get api_v1_carts_show_url, params: { cart_token: guest_cart_uncompleted.token }
    assert_response :success
    assert_not_nil response_body['token']
  end

  test "carts controller show should not return assigned cart contents to guest" do
    get api_v1_carts_show_url, params: { cart_token: user_cart_uncompleted.token }
    assert_response 401
    assert_nil response_body['token']
  end

  test "carts controller complete should complete unassigned uncompleted cart for guest" do
    post api_v1_carts_complete_url, params: { cart_token: guest_cart_uncompleted.token }
    assert_response :success
    assert_equal true, response_body['success']
  end

  test "carts controller complete should not complete unassigned completed cart for guest" do
    post api_v1_carts_complete_url, params: { cart_token: guest_cart_completed.token }
    assert_response 422
    assert_equal "cart_already_completed", response_body['error']
  end

  test "carts controller complete should not complete assigned uncompleted cart for guest" do
    post api_v1_carts_complete_url, params: { cart_token: user_cart_uncompleted.token }
    assert_response 401
    assert_equal "unauthorized", response_body['error']
  end

  test "carts controller complete should not complete assigned completed cart for guest" do
    post api_v1_carts_complete_url, params: { cart_token: user_cart_completed.token }
    assert_response 401
    assert_equal "unauthorized", response_body['error']
  end

  test "carts controller complete should destroy unassigned uncompleted cart for guest" do
    delete api_v1_carts_destroy_url, params: { cart_token: guest_cart_uncompleted.token }
    assert_response :success
    assert_equal true, response_body['success']
  end

  test "carts controller complete should not destroy unassigned completed cart for guest" do
    delete api_v1_carts_destroy_url, params: { cart_token: guest_cart_completed.token }
    assert_response 422
    assert_equal "cart_already_completed", response_body['error']
  end

  test "carts controller complete should not destroy assigned uncompleted cart for guest" do
    delete api_v1_carts_destroy_url, params: { cart_token: user_cart_uncompleted.token }
    assert_response 401
    assert_equal "unauthorized", response_body['error']
  end

  test "carts controller complete should not destroy assigned completed cart for guest" do
    delete api_v1_carts_destroy_url, params: { cart_token: user_cart_completed.token }
    assert_response 401
    assert_equal "unauthorized", response_body['error']
  end

  # User
  test "carts controller create should return new cart to logged in user" do
    post api_v1_carts_url, headers: authenticated_header
    assert_response :success
    assert_not_nil response_body['user']
    assert_not_nil response_body['token']
  end

  test "carts controller show should return assigned cart contents to logged in user" do
    get api_v1_carts_show_url, params: { cart_token: user_cart_uncompleted.token }, headers: authenticated_header
    assert_response :success
    assert_not_nil response_body['token']
  end

  test "carts controller show should return unassigned cart contents to logged in user" do
    get api_v1_carts_show_url, params: { cart_token: guest_cart_uncompleted.token }, headers: authenticated_header
    assert_response :success
    assert_not_nil response_body['token']
  end

  test "carts controller show should not return assigned cart contents to wrong user" do
    get api_v1_carts_show_url, params: { cart_token: user_cart_uncompleted.token }, headers: authenticated_header(:two)
    assert_response 401
    assert_equal "unauthorized", response_body['error']
  end

  test "carts controller complete should complete assigned uncompleted cart for logged in user" do
    post api_v1_carts_complete_url, params: { cart_token: user_cart_uncompleted.token }, headers: authenticated_header
    assert_response :success
    assert_equal true, response_body['success']
  end

  test "carts controller complete should not complete assigned completed cart for logged in user" do
    post api_v1_carts_complete_url, params: { cart_token: user_cart_completed.token }, headers: authenticated_header
    assert_response 422
    assert_equal "cart_already_completed", response_body['error']
  end

  test "carts controller complete should not complete assigned uncompleted cart for wrong user" do
    post api_v1_carts_complete_url, params: { cart_token: user_cart_uncompleted.token }, headers: authenticated_header(:two)
    assert_response 401
    assert_equal "unauthorized", response_body['error']
  end

  test "carts controller complete should not complete assigned completed cart for wrong user" do
    post api_v1_carts_complete_url, params: { cart_token: user_cart_completed.token }, headers: authenticated_header(:two)
    assert_response 401
    assert_equal "unauthorized", response_body['error']
  end

  test "carts controller complete should destroy assigned uncompleted cart for logged in user" do
    delete api_v1_carts_destroy_url, params: { cart_token: user_cart_uncompleted.token }, headers: authenticated_header
    assert_response :success
    assert_equal true, response_body['success']
  end

  test "carts controller complete should not destroy assigned uncompleted cart for wrong user" do
    delete api_v1_carts_destroy_url, params: { cart_token: user_cart_uncompleted.token }, headers: authenticated_header(:two)
    assert_response 401
    assert_equal "unauthorized", response_body['error']
  end

  test "carts controller complete should not destroy assigned completed cart for wrong user" do
    delete api_v1_carts_destroy_url, params: { cart_token: user_cart_completed.token }, headers: authenticated_header(:two)
    assert_response 401
    assert_equal "unauthorized", response_body['error']
  end

  test "carts controller complete should not destroy assigned completed cart for logged in user" do
    delete api_v1_carts_destroy_url, params: { cart_token: user_cart_completed.token }, headers: authenticated_header
    assert_response 422
    assert_equal "cart_already_completed", response_body['error']
  end

  # Both
  test "carts controller show should not return not-existing cart contents" do
    get api_v1_carts_show_url, params: { cart_token: "NOT EXISTING CART" }
    assert_response :missing
    assert_equal "not_found", response_body['error']
  end


  private
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

    def authenticated_header(key = :one)
      token = Knock::AuthToken.new(payload: { sub: users(key).id }).token

      {
          'Authorization': "Bearer #{token}"
      }
    end

end
