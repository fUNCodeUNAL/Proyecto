class CreateProblemContestRelationship < ActiveRecord::Migration[5.0]
  def change
    create_table :problem_contest_relationships do |t|
    	t.references :problem, foreign_key: true
	    t.references :contest, foreign_key: true
	    t.integer :score
    end
  end
end
