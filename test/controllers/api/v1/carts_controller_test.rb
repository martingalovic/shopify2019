require 'test_helper'

class Api::V1::CartsControllerTest < ActionDispatch::IntegrationTest
  test "should get show" do
    get api_v1_carts_index_url
    assert_response :success
  end

  test "should get create" do
    get api_v1_carts_create_url
    assert_response :success
  end

  test "should get delete" do
    get api_v1_carts_delete_url
    assert_response :success
  end

end
