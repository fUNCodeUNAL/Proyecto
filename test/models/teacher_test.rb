require 'test_helper'

class TeacherTest < ActiveSupport::TestCase
  test "should not save Teacher without a username" do
    teacher = Teacher.new()
    assert_not teacher.save
  end

  test "should not save Teacher with a repeated username" do
    teacher = Teacher.new(username: teachers(:one).username)
    assert_not teacher.save
  end
end
