class Student < ApplicationRecord
	
	has_many :has_groups, dependent: :destroy
	has_many :groups, through: :has_groups
	validates :username, presence: true, uniqueness: true
	#validates :cod	, numericality: { only_integer: true, greater_than: 0 }
	#validates :semester, numericality: { only_integer: true, greater_than: 0 }
end