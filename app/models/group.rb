class Group < ApplicationRecord
	belongs_to :teacher
	has_many :has_groups, dependent: :destroy
	has_many :students, through: :has_groups
	validates :name, presence: { message: "is required" }

end
