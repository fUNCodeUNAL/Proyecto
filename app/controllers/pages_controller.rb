class PagesController < ApplicationController
  def index
  end
  def profile
    @user = User.find_by(username: params[:username])
  	@student = Student.find_by(username: params[:username])
  	if @user == nil
  		render pages_wrong_path
    end
  end
end
