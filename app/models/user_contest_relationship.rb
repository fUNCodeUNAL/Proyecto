class UserContestRelationship < ApplicationRecord
	belongs_to :problem
	belongs_to :user 
	validate :user_unique_per_contest

	private
	def user_unique_per_contest
    if self.class.exists?(:user_id => user_id, :contest_id => contest_id)
      errors.add :user, 'Ya se encuentra registrado'
    end
  end
end