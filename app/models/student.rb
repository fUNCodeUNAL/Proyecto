class Student < ApplicationRecord
	has_and_belongs_to_many :groups
	self.primary_key = "email"
	validates :email, presence: true, uniqueness: { message: "is already taken"}, format: { with: /\A[a-zA-Z]+\z/, message: "only allows letters" }
	#validates :cod	, numericality: { only_integer: true, greater_than: 0 }
	#validates :semester, numericality: { only_integer: true, greater_than: 0 }
end