class PagesController < ApplicationController
  def index
  end
  def profile
  	#There is a problem with the "." character when its sent as id. So this line look for all the users which the given id is prefix of his email
  	#In the pages_wrong_path view shows a message to do a better search if there is more than one user.
    @user = User.find_by(username: params[:username])
  	@student = Student.find_by(username: params[:username])
  	if @user == nil
  		render pages_wrong_path
    end
  end
end
