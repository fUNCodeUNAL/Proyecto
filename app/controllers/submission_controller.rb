class SubmissionController < ApplicationController
  before_action :authenticate_user!, only: [:new]
  def new
  	@submission = Submission.new
  	
  end

  def create

   	verdict = getVerdict(params)

   	@submission = Submission.new(problem_id: params[:problem_id], user_id: current_user.id, verdict: verdict[0], execution_time: verdict[1], language: params[:submission][:language], code: params[:submission][:code], url_code: params[:submission][:file])
  	
  	if @submission.save
  		redirect_to ok_path
  	else
  		render :new
  	end


  	#redirect_to current_user.username + '/submission/'
  	
  end 

  def showUser
    user = User.find_by(username: params[:username])
  	@submissions = Submission.where( user_id: user.id ).order(created_at: :desc)
  end

  def showProblem
  	@submission = Submission.where( problem_id: params[:problem_id] ).order(created_at: :desc)
  end

  def showProblemUser
    user = User.find_by(username: params[:username])
  	@submission = Submission.where( user_id: user.id, user_username: params[:username] ).order(created_at: :desc)
  end

  private 

  #Falta obtener bien el veredicto y el tiempo de ejecucion
  def getVerdict(params)
  	return ["AC",0.0]
  end 

  def submission_params
    params.require(:submission).permit(:problem_id, :language)
  end
end
