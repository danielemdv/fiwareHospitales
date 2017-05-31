require 'test_helper'

class HospitalControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get hospital_index_url
    assert_response :success
  end

end
