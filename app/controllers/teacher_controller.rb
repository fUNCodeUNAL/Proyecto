class TeacherController < ApplicationController
  before_action :authenticate_user!
  def show_groups
    @teacher = Teacher.find_by(username: current_user.username)
    @user = current_user
  end
end
