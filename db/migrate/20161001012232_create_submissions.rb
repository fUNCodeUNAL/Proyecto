class CreateSubmissions < ActiveRecord::Migration[5.0]
  def change
    create_table :submissions do |t|
      t.string :verdict
      t.string :language
      t.float :execution_time
      t.text :url_code

      t.timestamps
    end
  end
end
