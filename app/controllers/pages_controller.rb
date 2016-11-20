class PagesController < ApplicationController

  before_action :init_pagination, only: [ :search ]

  def index
  end

  def profile
    @user = User.find_by(username: params[:username])
    @student = Student.find_by(username: params[:username])
    if @user == nil
      render pages_wrong_path
    end

    @submission = Submission.where('user_id LIKE ? AND final_verdict NOT IN ("Pending", "Internal Error")', @user.id).select('final_verdict, COUNT(final_verdict) as total').group(:final_verdict)

    @submission_data = [ ['Verdict', 'Count'] ]
    @submission.each do |sub|
      @submission_data.push( [ sub.final_verdict, sub.total ] )
    end

  end
  
  def search
    maxQuery = 10
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

  def new_teacher
    if !user_signed_in? or Teacher.where(username: current_user.username).count == 0
      redirect_to pages_wrong_path
    end
  end

  def create_teacher
    teacher = Teacher.new(username: params[:username])
    if teacher.save
      Student.find_by(username: params[:username]).destroy
      redirect_to pages_index_path
    else
      redirect_to pages_wrong_path
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
