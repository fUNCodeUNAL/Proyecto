class AddUserUsernameToSubmissions < ActiveRecord::Migration[5.0]
  def change
    add_column :submissions, :user_username, :string, references: :user
    #add_reference :submissions, :user_username, :string, foreign_key: true
  end
end
