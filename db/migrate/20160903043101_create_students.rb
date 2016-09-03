class CreateStudents < ActiveRecord::Migration[5.0]
  def change
    create_table :students, id: false do |t|
      t.string :email, null: false
      t.integer :cod
      t.integer :semester

      t.timestamps
    end
  end
end
