class Submission < ApplicationRecord
	belongs_to :user
   	belongs_to :problem
   	mount_uploader :url_code, CodeUploader

   	validate :at_least_one

	def at_least_one
		unless [url_code?, code?].include?(true)
	    	errors.add :base, 'Debe subir un archivo o el codigo fuente'
		end
	end     
end
