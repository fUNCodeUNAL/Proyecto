require 'open-uri'
require 'httparty'
require 'json'
require 'tempfile'
require 'judge_api'
require 'file_manager'

class SubmissionController < ApplicationController
  before_action :authenticate_user!, only: [:new]
  before_action :init_pagination, only: [ :showUser, :showProblem, :showProblemUser, :paginate ]

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

  
  def show_details_submission
    fileM = FileManager.new
    submission = Submission.find_by( id: params[ :submission_id ] )
    @code = fileM.get_data_url( submission.url_code.url )
    @verdicts = get_verdicts( fileM, submission )
    @test_cases = parsing_test_cases( fileM, get_test_cases( submission ) )
    render layout: 'light_view'
  end

  
  def showUser
    maxQuery = 2
    submissionStartId = params[:pageIdSubm].to_i*maxQuery

    user = User.find_by(username: params[:username])
    @submissions = Submission.where( user_id: user.id ).offset(submissionStartId).limit(maxQuery)
    @submissionsTotal = Submission.where( user_id: user.id ).count

    if submissionStartId+maxQuery >= @submissionsTotal
      @disableSubmNextButton = " disabled"
    end
    if submissionStartId == 0
      @disableSubmPrevButton = " disabled"
    end

    @pendingSubmissions = Submission.where( user_id: user.id, verdict: "Pending", in_queue: false)
    updatePendingSubmissions()

  end

  def showProblem
    maxQuery = 2
    submissionStartId = params[:pageIdSubm].to_i*maxQuery

    @submissions = Submission.where( problem_id: params[:problem_id] ).offset(submissionStartId).limit(maxQuery)
    @submissionsTotal = Submission.where( problem_id: params[:problem_id] ).count

    if submissionStartId+maxQuery >= @submissionsTotal
      @disableSubmNextButton = " disabled"
    end
    if submissionStartId == 0
      @disableSubmPrevButton = " disabled"
    end

    @pendingSubmissions = Submission.where( problem_id: params[:problem_id], verdict: "Pending", in_queue: false)
    updatePendingSubmissions()
  end

  
  def showProblemUser
    maxQuery = 2
    submissionStartId = params[:pageIdSubm].to_i*maxQuery

    user = User.find_by(username: params[:username])
    @submissions = Submission.where( user_id: user.id, problem_id: params[:problem_id] ).offset(submissionStartId).limit(maxQuery)
    @submissionsTotal = Submission.where( user_id: user.id, problem_id: params[:problem_id] ).count

    if submissionStartId+maxQuery >= @submissionsTotal
      @disableSubmNextButton = " disabled"
    end
    if submissionStartId == 0
      @disableSubmPrevButton = " disabled"
    end

    @pendingSubmissions = Submission.where( user_id: user.id, problem_id: params[:problem_id], verdict: "Pending", in_queue: false)
    updatePendingSubmissions()
  end

  
  def paginate

    maxQuery = 2
    submissionStartId = params[:pageIdSubm].to_i*maxQuery

    if( params[:table].eql?"user" )
      user = User.find_by(username: params[:username])
      @submissions = Submission.where( user_id: user.id ).offset(submissionStartId).limit(maxQuery).order(params[:order])
      @submissionsTotal = Submission.where( user_id: user.id ).count
    elsif( params[:table].eql?"problem" )
      @submissions = Submission.where( problem_id: params[:problem_id] ).offset(submissionStartId).limit(maxQuery).order(params[:order])
      @submissionsTotal = Submission.where( problem_id: params[:problem_id] ).count
    else
      user = User.find_by(username: params[:username])
      @submissions = Submission.where( user_id: user.id, problem_id: params[:problem_id] ).offset(submissionStartId).limit(maxQuery).order(params[:order])
      @submissionsTotal = Submission.where( user_id: user.id, problem_id: params[:problem_id] ).count
    end

    if submissionStartId+maxQuery >= @submissionsTotal
      @disableSubmNextButton = " disabled"
    end
    if submissionStartId == 0
      @disableSubmPrevButton = " disabled"
    end

  end

  
  private 

  def init_pagination
    @disableSubmPrevButton = ""
    @disableSubmNextButton = ""

    @send_order ={
      'id' => "DESC",
      'problem_id' => "DESC",
      'user_id' => "DESC",
      'verdict' => "DESC",
      'language' => "DESC",
      'execution_time' => "DESC",
      'created_at' => "DESC"
    }
    @icon_order ={
      'id' => "",
      'problem_id' => "",
      'user_id' => "",
      'verdict' => "",
      'language' => "",
      'execution_time' => "",
      'created_at' => ""
    }

    if params.has_key?( :order ) and params[:order].split[1].eql?"DESC"
      field = params[:order].split[0]
      @send_order[ field ] = "ASC"
      @icon_order[ field ] = "-alt"
    end

  end

  def get_verdicts( file_manager, submission )
    judge = JudgeApi.new
    verdicts = [ ]
    api_ids = submission.api_ids.split(';')
    count = 0
    passedTest = 0
    time = 0
    api_ids.each do |id|
      verdict = judge.getStatus(id)
      status = verdict['status']['description']
      time = verdict['time']
      if time.nil?
        time = "0"
      end
      memory = verdict['memory']
      if memory.nil?
        memory = "0"
      end
      output = verdict['actual_output']
      verdicts.push( [ status, time, memory, output ] )
    end
    return verdicts
  end

  # Uses a @pendingSubmission class variable that is defined in any show method
  def updatePendingSubmissions()
    @pendingSubmissions.each do |submission|
      submission.update(in_queue: true)
      GetVerdictJob.perform_later(submission.id)
    end
  end

  # Function to submit a code to the API
  # Uses a @submission class variable that is defined in create
  # Return the Ids for the submissions test case. (See GetVeredictJob)
  def sendSubmission()
    fileM = FileManager.new
    code = fileM.get_data_url( @submission.url_code.url )
    judge = JudgeApi.new
    test_cases = parsing_test_cases( fileM, get_test_cases( @submission ) )
    api_ids = ""
    test_cases.each do |test_case|
      language = @submission.language
      input = test_case[ 0 ]
      output = test_case[ 1 ]
      id = judge.sendSubmission(code, language, input, output)
      api_ids = api_ids + id.to_s + ";"
    end
    return api_ids;
  end 

  def get_test_cases( submission )
    test_cases = Problem.find_by( id: submission.problem_id ).test_cases
    return test_cases
  end

  def submission_params
    params.require(:submission).permit(:problem_id, :language)
  end

  def parsing_test_cases( file_manager, tc )
    test_cases = [ ]
    tc.each do |test_case|
      test_cases.push( [ file_manager.get_data_url( test_case.url_input.url ), file_manager.get_data_url(test_case.url_output.url) ] )
    end
    return test_cases
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
