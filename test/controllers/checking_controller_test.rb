require 'test_helper'

class CheckingControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get checking_index_url
    assert_response :success
  end

  test "should get result" do
    get checking_result_url
    assert_response :success
  end

end
