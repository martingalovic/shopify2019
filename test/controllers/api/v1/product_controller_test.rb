require 'test_helper'

class Api::V1::ProductControllerTest < ActionDispatch::IntegrationTest
  test "products controller show should return product" do
    product = Product.first
    get api_v1_product_url(product.id)
    assert_response :success
    assert_not_nil response_body['id']
  end

  test "products controller index should return list" do
    get api_v1_products_url
    assert_response :success
    assert_not_nil response_body['products']
  end

  test "products controller index only available should return list" do
    get api_v1_products_url, params: {available: true}
    assert_response :success

    is_there_any_unavailable = false
    response_body['products'].each do |product|
      if product['inventory_count'] <= 0
        is_there_any_unavailable = true
        break
      end
    end

    assert_equal false, is_there_any_unavailable, "products controller index only available included product which was out of stock"
  end

end
