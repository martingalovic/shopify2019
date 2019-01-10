require 'test_helper'

class Api::V1::CartItemsControllerTest < ActionDispatch::IntegrationTest
  test "should get new" do
    get api_v1_cart_items_new_url
    assert_response :success
  end

end
