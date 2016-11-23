class TeacherController < ApplicationController
  before_action :authenticate_user!
  load_and_authorize_resource
  
  def show_groups
  	teacher_id = Teacher.find_by(username: current_user.username).id
    @teacher = Teacher.find_by(id: teacher_id)
    @user = current_user
  end
end
