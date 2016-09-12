class CreateTeachers < ActiveRecord::Migration[5.0]
  def change
    create_table :teachers, id: false do |t|
      t.string :username, null: false

      t.timestamps
    end
  end
end
