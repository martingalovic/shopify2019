require 'test_helper'

class Api::V1::ProductControllerTest < ActionDispatch::IntegrationTest
  test "should get show" do
    product = Product.first
    get api_v1_product_url(product.id)
    assert_response :success
  end

  test "should get list" do
    get api_v1_products_url
    assert_response :success
  end

  test "should get list only available" do
    get api_v1_products_url, params: {available: true}
    assert_response :success
  end

end
