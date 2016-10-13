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
  	@users = User.where("lower(username) LIKE ?", "%#{params[:search].downcase}%").take(maxQuery)
    if( is_number?( params[:search] ) )
      @problems = Problem.where("id = ? or lower(name) LIKE ?", Integer("#{params[:search]}"), "%#{params[:search].downcase}%").take(maxQuery)
    else
      @problems = Problem.where("lower(name) LIKE ?", "%#{params[:search].downcase}%").take(maxQuery)
    end
  end

  
  private

  def is_number? string
    true if Integer(string) rescue false
  end

end
