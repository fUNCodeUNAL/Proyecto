class TeacherController < ApplicationController
  before_action :authenticate_user!
  def show_groups
    @teacher = Teacher.find_by(id: current_user.id)
    @user = current_user
  end
end
