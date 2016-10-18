require 'open-uri'
require 'httparty'
require 'json'
require 'tempfile'
require 'judge_api'

class SubmissionController < ApplicationController
  before_action :authenticate_user!, only: [:new]
  def new
  	@submission = Submission.new
    @available_languages = get_list_languages( Problem.find(params[:problem_id]).languages )
  end

  def create
    if(params[:file] != nil)
   	  @submission = Submission.new(problem_id: params[:problem_id], user_id: current_user.id, verdict: "Pending", execution_time: "-", language: params[:submission][:language], url_code: params[:file])
    else
      filename = get_filename(params[:submission][:language])
      file = Tempfile.new(filename)
      file.write(params[:code])
      file.close
      filepath = file.path
      @submission = Submission.new(problem_id: params[:problem_id], user_id: current_user.id, verdict: "Pending", execution_time: "-", language: params[:submission][:language], url_code: File.open(filepath))
    end 
  	
  	if @submission.save
      @submission.api_ids = sendSubmission()
      @submission.in_queue = false
      @submission.save
      redirect_to submissions_user_path(current_user.username)
    else
      render :new
    end
  	#redirect_to current_user.username + '/submission/'
  end 

  def showUser
    user = User.find_by(username: params[:username])
    @submissions = Submission.where( user_id: user.id ).order(created_at: :desc)
    @pendingSubmissions = Submission.where( user_id: user.id, verdict: "Pending", in_queue: false)
    @users = mapUsers( @submissions )
    updatePendingSubmissions()
  end

  def showProblem
    @submissions = Submission.where( problem_id: params[:problem_id] ).order(created_at: :desc)
    @pendingSubmissions = Submission.where( problem_id: params[:problem_id], verdict: "Pending", in_queue: false)
    @users = mapUsers( @submissions )
    updatePendingSubmissions()
  end

  def showProblemUser
    user = User.find_by(username: params[:username])
    @submissions = Submission.where( user_id: user.id, problem_id: params[:problem_id] ).order(created_at: :desc)
    @pendingSubmissions = Submission.where( user_id: user.id, problem_id: params[:problem_id], verdict: "Pending", in_queue: false)
    @users = mapUsers( @submissions )
    updatePendingSubmissions()
  end

  private 

  # Uses a @pendingSubmission class variable that is defined in any show method
  def updatePendingSubmissions()
    @pendingSubmissions.each do |submission|
      submission.update(in_queue: true)
      GetVerdictJob.perform_later(submission.id)
    end
  end

  # Return a string with the information of a file from the given url
  def get_data_url( path )
    url = URI.parse( path )
    data = ""
    open( url ) do |http|
      data = http.read
    end
    return data
  end

  # Function to submit a code to the API
  # Uses a @submission class variable that is defined in create
  # Return the Ids for the submissions test case. (See GetVeredictJob)
  def sendSubmission()
    code = get_data_url( @submission.url_code.url )
    judge = JudgeApi.new
    test_cases = Problem.find_by( id: @submission.problem_id ).test_cases
    api_ids = ""
    test_cases.each do |test_case|
      language = @submission.language
      input = get_data_url(test_case.url_input.url)
      output = get_data_url(test_case.url_output.url)
      id = judge.sendSubmission(code, language, input, output)
      api_ids = api_ids + id.to_s + ";"
    end
    return api_ids;
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

  def get_filename( language )
    if(language == "Java")
      return "code.java"
    end
    if(language == "C++")
      return "code.cpp"
    end
    if(language == "Python")
      return "code.py"
    end
    if(language == "C")
      return "code.c"
    end
  end

  def get_list_languages( languages )
    array = []
    if ( ( languages>>0 )&1 ) == 1
      array.push(['C++', 'C++'])
    end
    if ( ( languages>>1 )&1 ) == 1 
      array.push(['Java', 'Java'])
    end
    if ( ( languages>>2 )&1 ) == 1 
      array.push(['Python', 'Python'])
    end
    if ( ( languages>>3 )&1 ) == 1 
      array.push(['C', 'C'])
    end
    return array
  end 
end
