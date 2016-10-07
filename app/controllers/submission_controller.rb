class SubmissionController < ApplicationController
  before_action :authenticate_user!, only: [:new]
  def new
  	@submission = Submission.new
  	
  end

  def create

   	verdict = getVerdict(params)

   	@submission = Submission.new(problem_id: params[:problem_id], user_id: current_user.id, verdict: verdict[0], execution_time: verdict[1], language: params[:submission][:language], code: params[:submission][:code], url_code: params[:submission][:file])
  	
  	if @submission.save
  		redirect_to submissions_user_path(current_user.username)
  	else
  		render :new
  	end


  	#redirect_to current_user.username + '/submission/'
  	
  end 

  def showUser
    user = User.find_by(username: params[:username])
  	@submissions = Submission.where( user_id: user.id ).order(created_at: :desc)
    @users = mapUsers( @submissions )
  end

  def showProblem
  	@submissions = Submission.where( problem_id: params[:problem_id] ).order(created_at: :desc)
    @users = mapUsers( @submissions )
  end

  def showProblemUser
    user = User.find_by(username: params[:username])
  	@submissions = Submission.where( user_id: user.id, problem_id: params[:problem_id] ).order(created_at: :desc)
    @users = mapUsers( @submissions )
  end

  private 

  #Falta obtener bien el veredicto y el tiempo de ejecucion
  def getVerdict(params)
  	return ["AC",0.0]
  end 

  def submission_params
    params.require(:submission).permit(:problem_id, :language)
  end


  def mapUsers( submissions )
    m = {}
    @submissions.each do |submission|
      if !m.has_key?( submission.user_id )
        m[submission.user_id] = User.find( submission.user_id ).username
      end
    end
    return m
  end

end
