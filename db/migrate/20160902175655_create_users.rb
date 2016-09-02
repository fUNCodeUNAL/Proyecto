class CreateUsers < ActiveRecord::Migration[5.0]
  def change
    create_table :users do |t|
      t.string :email, :primary_key
      t.string :full_name
      t.string :password

      t.timestamps
    end
  end
end