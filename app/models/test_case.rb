class TestCase < ApplicationRecord
	mount_uploader :url_input, FileUploader
	mount_uploader :url_output, FileUploader
	belongs_to :problem
end
