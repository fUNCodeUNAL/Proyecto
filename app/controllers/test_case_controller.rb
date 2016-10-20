require 'file_manager'

class TestCaseController < ApplicationController

	before_action :authenticate_user!, only: [ :show_test_case, :edit ]

	def show_test_case
		fileM = FileManager.new
		@input = fileM.get_data_url( Problem.find(params[:problem_id]).test_cases[ params[:test_idx].to_i ].url_input.url )
		@output = fileM.get_data_url( Problem.find(params[:problem_id]).test_cases[ params[:test_idx].to_i ].url_output.url )
		#render :layout => false
	end

	def edit
		file = Tempfile.new("tempFile")
		file.write(params[:input])
		file.close
		filepath = file.path
		Problem.find( params[:problem_id] ).test_cases[ params[:test_idx].to_i ].update( url_input: File.open(filepath) )

		file = Tempfile.new("tempFile")
		file.write(params[:output])
		file.close
		filepath = file.path
		Problem.find( params[:problem_id] ).test_cases[ params[:test_idx].to_i ].update( url_output: File.open(filepath) )
		
		redirect_to problem_edit_path( params[:problem_id] )
	end

end
