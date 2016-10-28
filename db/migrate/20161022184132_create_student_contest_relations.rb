class CreateStudentContestRelations < ActiveRecord::Migration[5.0]
  def change
    create_table :student_contest_relations do |t|
      t.references :student, foreign_key: true
      t.references :contest, foreign_key: true
    end
  end
end
