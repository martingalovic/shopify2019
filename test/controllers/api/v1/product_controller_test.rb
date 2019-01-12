require 'test_helper'

class Api::V1::ProductControllerTest < ActionDispatch::IntegrationTest
  test "products controller show should return product" do
    product = Product.first
    get api_v1_product_url(product.id)
    assert_response :success
  end

  test "products controller index should return list" do
    get api_v1_products_url
    assert_response :success
  end

  test "products controller index only available should return list" do
    get api_v1_products_url, params: {available: true}
    assert_response :success
  end

end
