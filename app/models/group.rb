class Group < ApplicationRecord
	has_and_belongs_to_many :students
	belongs_to :teacher
	validates :name, presence: { message: "is required" }

end
