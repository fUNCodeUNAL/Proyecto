class Teacher < ApplicationRecord
	has_many :groups
	self.primary_key = "username"
	validates :username, uniqueness: true, presence: true
end
