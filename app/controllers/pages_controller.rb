class PagesController < ApplicationController

  before_action :init_pagination, only: [ :search ]

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
    maxQuery = 2
    problemStartId = params[:pageIdProblem].to_i*maxQuery
    userStartId = params[:pageIdUser].to_i*maxQuery

    @users = User.where("lower(username) LIKE ?", "%#{params[:search].downcase}%").offset(userStartId).limit(maxQuery)
    @usersTotal = User.where("lower(username) LIKE ?", "%#{params[:search].downcase}%").count
    if( is_number?( params[:search] ) )
      @problems = Problem.where("id = ? or lower(name) LIKE ?", Integer("#{params[:search]}"), "%#{params[:search].downcase}%").offset(problemStartId).limit(maxQuery).order(params[:order])
      @problemTotal = Problem.where("id = ? or lower(name) LIKE ?", Integer("#{params[:search]}"), "%#{params[:search].downcase}%").count
    else
      @problems = Problem.where("lower(name) LIKE ?", "%#{params[:search].downcase}%").offset(problemStartId).limit(maxQuery).order(params[:order])
      @problemTotal = Problem.where("lower(name) LIKE ?", "%#{params[:search].downcase}%").count
    end

    if userStartId+maxQuery >= @usersTotal
      @disableUserNextButton = " disabled"
    end
    if userStartId == 0
      @disableUserPrevButton = " disabled"
    end

    if problemStartId+maxQuery >= @problemTotal
      @disableProblemNextButton = " disabled"
    end
    if problemStartId == 0
      @disableProblemPrevButton = " disabled"
    end
  end

  
  private

  def init_pagination
    @disableUserPrevButton = ""
    @disableUserNextButton = ""
    @disableProblemPrevButton = ""
    @disableProblemNextButton = ""

    @send_order ={
      'id' => "DESC",
      'name' => "DESC",
      'created_at' => "DESC",
      'username' => "DESC",
      'full_name' => "DESC",
      'email' => "DESC"
    }
    @icon_order ={
      'id' => "",
      'name' => "",
      'created_at' => "",
      'username' => "",
      'full_name' => "",
      'email' => ""
    }
  end

  def is_number? string
    true if Integer(string) rescue false
  end

end
