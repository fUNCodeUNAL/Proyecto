class CreateStudentsGroups < ActiveRecord::Migration[5.0]
  def change
    create_table :students_groups do |t|
    	t.integer :student_id
    	t.integer :group_id
    end
  end
end
