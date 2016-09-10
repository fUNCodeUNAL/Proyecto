class Teacher < ApplicationRecord
	has_many :groups
	self.primary_key = "email"
	validates :email, uniqueness: { message: "is already taken"}
  	validates :email, presence: { message: "is required" }
end
