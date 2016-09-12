class PagesController < ApplicationController
  def index
  end
  def profile
  	#There is a problem with the "." character when its sent as id. So this line look for all the users which the given id is prefix of his email
  	#In the pages_wrong_path view shows a message to do a better search if there is more than one user.
=begin
  	@allStudent = Student.where("email LIKE ? ", params[:id]+'%')
  	if @allStudent.count > 1
  		render pages_wrong_path
  	else
  		@student = @allStudent[0]
  		@user = User.find(@student.email)
  	end
=end
  end
end
