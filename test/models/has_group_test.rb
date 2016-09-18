require 'test_helper'

class HasGroupTest < ActiveSupport::TestCase
  test "should not save HasGroup without a group_id" do
    record = HasGroup.new(student_id: students(:one).username)
    assert_not record.save
  end

  test "should not save HasGroup without a student_id" do
    record = HasGroup.new(group_id: groups(:one).id)
    assert_not record.save
  end

  test "should save HasGroup without errors" do
    record = HasGroup.new(group_id: groups(:two).id, student_id: students(:one).username)
    assert record.save
  end
end
