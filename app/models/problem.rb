class Problem < ApplicationRecord
	# Pending: add :url_statement
	validates :name, :time_limit, presence: true
	validates :languages, numericality: { greater_than: 0, message: "Debe estar disponible en al menos un lenguaje" }
end
