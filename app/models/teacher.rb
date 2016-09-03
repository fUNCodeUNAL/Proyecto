class Teacher < ApplicationRecord
	self.primary_key = "email"
	validates :email, uniqueness: { message: "is already taken"}, format: { with: /\A[a-zA-Z]+\z/, message: "only allows letters" }
  	validates :email, presence: { message: "is required" }
end
