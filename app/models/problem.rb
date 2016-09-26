class Problem < ApplicationRecord
	mount_uploader :url_statement, FileUploader
	validates :name, :time_limit, presence: true
	validates :languages, numericality: { greater_than: 0, message: "Debe estar disponible en al menos un lenguaje" }
	has_many :test_cases
end
