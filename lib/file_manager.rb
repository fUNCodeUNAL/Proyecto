class FileManager

	def get_data_url( path )
		url = URI.parse( path )
		data = ""
		open( url ) do |http|
			data = http.read
		end
		return data
	end

end