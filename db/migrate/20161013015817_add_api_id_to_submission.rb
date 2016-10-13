class AddApiIdToSubmission < ActiveRecord::Migration[5.0]
  def change
  	add_column :submissions, :api_ids, :string
  	add_column :submissions, :in_queue, :boolean
  end
end
