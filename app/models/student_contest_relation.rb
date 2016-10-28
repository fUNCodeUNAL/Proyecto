class StudentContestRelation < ApplicationRecord
  belongs_to :student
  belongs_to :contest
end
