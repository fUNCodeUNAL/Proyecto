class TeacherController < ApplicationController
  def show_groups
  	#There is a problem with the "." character when its sent as id. So this line look for all the users which the given id is prefix of his email
  	#In the pages_wrong_path view shows a message to do a better search if there is more than one user.
  	@allTeachers = Teacher.where("email LIKE ? ", params[:id]+'%')
  	if @allTeachers.count > 1
  		render pages_wrong_path
  	else
  		@teacher = @allTeachers[0]
  		@user = User.find(@teacher.email)
  	end
  end
end
