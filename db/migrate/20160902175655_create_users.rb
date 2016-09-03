class CreateUsers < ActiveRecord::Migration[5.0]
  def change
    create_table :users, id: false do |t|
      t.string :full_name
      t.string :email, null: false
      t.string :password

      t.timestamps
    end
  end
end