class AddTeacherRefToContest < ActiveRecord::Migration[5.0]
  def change
    add_reference :contests, :teacher, foreign_key: true
  end
end
