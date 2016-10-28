class Contest < ApplicationRecord
	belongs_to :teacher
	validates :name, :start_date, :end_date, presence: { message: "es obligatorio" }
	validate :dates_are_correct

	has_many :problem_contest_relationships, dependent: :destroy
	has_many :problems, through: :problem_contest_relationships

	has_many :user_contest_relationships, dependent: :destroy
	has_many :users, through: :user_contest_relationships

	def dates_are_correct
	    if start_date < end_date == false
	      errors.add(:start_date, 'debe ser antes de la fecha final')
	    end
  	end
end
