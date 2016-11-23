class AddFinalVerdictToSubmissions < ActiveRecord::Migration[5.0]
  def change
  	add_column :submissions, :final_verdict, :string
  end
end
