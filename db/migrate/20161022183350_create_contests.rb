class CreateContests < ActiveRecord::Migration[5.0]
  def change
    create_table :contests do |t|
      t.datetime :start_date
      t.datetime :end_date
      t.string :name

      t.timestamps
    end
  end
end
