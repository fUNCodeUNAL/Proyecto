require 'test_helper'

class GroupTest < ActiveSupport::TestCase
  test "should not save group without a name" do
    group = Group.new
    assert_not group.save
  end

  test "should not save group without a teacher" do
    group = Group.new(name: "Group1")
    assert_not group.save
  end

  test "should save group without errors" do
    group = Group.new(name: "Test group 1", teacher_id: teachers(:one).username)
    assert group.save
  end
end

