class AddGroupIdToTeacher < ActiveRecord::Migration[5.0]
  def change
    add_reference :groups, :teacher, foreign_key: true
  end
end
