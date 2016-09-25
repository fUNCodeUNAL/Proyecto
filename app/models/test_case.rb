class TestCase < ApplicationRecord
	mount_uploader :url_input, :url_output, DocumentUploader
	belongs_to :problem
end
