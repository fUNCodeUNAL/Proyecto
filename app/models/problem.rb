class Problem < ApplicationRecord
	mount_uploader :url_statement, FileUploader
	validates_processing_of :url_statement
	validates :name, :time_limit, presence: { message: "no puede estar vacio" }
	validates :time_limit, numericality: { message: "debe ser un numero" }
	validates :languages, numericality: { greater_than: 0, message: "debe estar disponible en al menos un lenguaje" }
	has_many :test_cases
    has_many :submissions
end
