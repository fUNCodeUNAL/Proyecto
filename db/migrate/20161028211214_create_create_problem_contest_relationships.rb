class CreateCreateProblemContestRelationships < ActiveRecord::Migration[5.0]
  def change
    create_table :create_problem_contest_relationships do |t|

      t.timestamps
    end
  end
end
