class Group < ApplicationRecord
	validates :name, presence: { message: "is required" }
end
