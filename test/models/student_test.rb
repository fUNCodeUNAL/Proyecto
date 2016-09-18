require 'test_helper'

class StudentTest < ActiveSupport::TestCase
  test "should not save Student without a username" do
    student = Student.new()
    assert_not student.save
  end

  test "should not save Student with a repeated username" do
    student = Student.new(username: students(:one).username)
    assert_not student.save
  end
end
