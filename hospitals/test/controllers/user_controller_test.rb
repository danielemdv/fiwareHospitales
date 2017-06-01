require 'test_helper'

class UserControllerTest < ActionDispatch::IntegrationTest
  test "should get entry" do
    get user_entry_url
    assert_response :success
  end

end
