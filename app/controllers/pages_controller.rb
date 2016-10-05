class PagesController < ApplicationController
  def index
  end

  def profile
    @user = User.find_by(username: params[:username])
  	@student = Student.find_by(username: params[:username])
  	if @user == nil or @student == nil
  		render pages_wrong_path
    end
  end
  
  def search
  	maxQuery = 100
  	@users = User.where("username LIKE ?", "%#{params[:search]}%").take(maxQuery)
    @problems = Problem.where("id LIKE ? or name LIKE ?", "#{params[:search]}", "%#{params[:search]}%").take(maxQuery)
  end
end
