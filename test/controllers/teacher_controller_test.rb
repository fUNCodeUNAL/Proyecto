require 'test_helper'

class TeacherControllerTest < ActionDispatch::IntegrationTest
  test "should get show_groups" do
    get teacher_show_groups_url
    assert_response :success
  end

end
