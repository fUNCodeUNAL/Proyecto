class TeacherController < ApplicationController
  def show_groups
  	@teacher = Teacher.find_by(username: params[:username])
  	@user = User.find_by(username: params[:username])
  	if @teacher == nil or current_user == nil or current_user.username != params[:username]
      render pages_wrong_path
  	end
  end
end
