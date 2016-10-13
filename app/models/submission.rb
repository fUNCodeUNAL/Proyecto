class Submission < ApplicationRecord
	belongs_to :user
   	belongs_to :problem
   	mount_uploader :url_code, CodeUploader   
end
