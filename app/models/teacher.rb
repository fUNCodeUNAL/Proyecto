class Teacher < ApplicationRecord
	has_many :groups, dependent: :destroy
	
	validates :username, uniqueness: true, presence: true
end
