class CreateUserContestRelationship < ActiveRecord::Migration[5.0]
  def change
    create_table :user_contest_relationships do |t|
    	t.references :user, foreign_key: true
      	t.references :contest, foreign_key: true
    end
  end
end
