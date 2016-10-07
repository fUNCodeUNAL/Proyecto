class CreateStudents < ActiveRecord::Migration[5.0]
  def change
    create_table :students do |t|
      t.string :username, null: false
      t.integer :cod
      t.integer :semester

      t.timestamps
    end
  end
end
