class Contest < ApplicationRecord
	belongs_to :teacher
	
	attr_accessor :contest_running

	validates :name, :start_date, :end_date, presence: { message: "es obligatorio" }
	validate :dates_are_correct
	validate :valid_initial_date, unless: :contest_running

	has_many :problem_contest_relationships, dependent: :destroy
	has_many :problems, through: :problem_contest_relationships

	has_many :user_contest_relationships, dependent: :destroy
	has_many :users, through: :user_contest_relationships

	def dates_are_correct
		# Esto es para evita que una persona temine un contest en tiempo anterior al actual
		# pero posterior al start_date
		cur_time = Time.new + 5*60
	    if start_date < end_date == false
	      errors.add(:start_date, 'debe ser antes de la fecha final')
	    elsif cur_time < end_date == false
	      errors.add(:end_date, 'El contest no puede terminar tan pronto')
	    end
  	end

  	def valid_initial_date
		#Esto es para que el contest empiece minimo 5 minutos despues de la fecha actual
		cur_time = Time.new + 5*60
	    if cur_time < start_date == false 
	      errors.add(:start_date, 'debe ser al menos 5 minutos despues de la fecha actual')
	    end

  	end

end
