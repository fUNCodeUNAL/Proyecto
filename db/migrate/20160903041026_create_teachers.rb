class CreateTeachers < ActiveRecord::Migration[5.0]
  def change
    create_table :teachers do |t|
      t.string :username, null: false

      t.timestamps
    end
  end
end
