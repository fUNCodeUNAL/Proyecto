class TeacherController < ApplicationController
  def show_groups
  	
  	@teacher = Teacher.find(current_user.email)
  	
  	if @teacher == nil
      render pages_wrong_path
    else
  		@user = current_user
  	end
  end
end
