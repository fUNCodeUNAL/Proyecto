require 'test_helper'

class SubmissionControllerTest < ActionDispatch::IntegrationTest
  test "should get new" do
    get submission_new_url
    assert_response :success
  end

end
