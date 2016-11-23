class ProblemContestRelationship < ApplicationRecord
	belongs_to :problem
	belongs_to :contest 
end