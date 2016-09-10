class Student < ApplicationRecord
	self.primary_key = "email"
	has_many :has_groups
	has_many :groups, through: :has_groups
	validates :email, presence: true, uniqueness: { message: "is already taken"}
	#validates :cod	, numericality: { only_integer: true, greater_than: 0 }
	#validates :semester, numericality: { only_integer: true, greater_than: 0 }
end