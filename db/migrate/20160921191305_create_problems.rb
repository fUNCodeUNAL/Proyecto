class CreateProblems < ActiveRecord::Migration[5.0]
  def change
    create_table :problems do |t|
      t.string :name
      t.string :url_statement
      t.float :time_limit
      t.integer :languages

      t.timestamps
    end
  end
end
