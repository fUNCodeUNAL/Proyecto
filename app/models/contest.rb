class Contest < ApplicationRecord
	belongs_to :teacher
	has_many :students, through: :student_contest_relation
	has_many :problems, through: :problem_contest_relation
	validates :name, :start_date, :end_date, presence: { message: "es obligatorio" }
	validate :dates_are_correct

	def dates_are_correct
	    if start_date < end_date == false
	      errors.add(:start_date, 'debe ser antes de la fecha final')
	    end
  	end
end
