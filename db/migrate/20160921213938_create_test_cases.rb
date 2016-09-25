class CreateTestCases < ActiveRecord::Migration[5.0]
  def change
    create_table :test_cases do |t|
      t.string :url_input
      t.string :url_output

      t.timestamps
    end
  end
end
