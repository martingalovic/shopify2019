require 'test_helper'

class Api::V1::UserTokenControllerTest < ActionDispatch::IntegrationTest
  test "user token controller should return token" do
    user = User.first
    post api_v1_login_url, params: { auth: { username: user.username, password: 'shop' } }
    assert_response :success
    assert_not_nil response_body['jwt']
  end

  test "user token controller should not return token if wrong credentials" do
    post api_v1_login_url, params: { auth: { username: 'WRONG USERNAME', password: 'WRONG PASSWORD' } }
    assert_nil response_body["jwt"]
  end

end
