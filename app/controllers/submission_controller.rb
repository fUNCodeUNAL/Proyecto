require 'open-uri'
require 'httparty'
require 'json'

class SubmissionController < ApplicationController
  before_action :authenticate_user!, only: [:new]
  def new
  	@submission = Submission.new
  	
  end

  def create

   	@submission = Submission.new(problem_id: params[:problem_id], user_id: current_user.id, verdict: "Pending", execution_time: "-", language: params[:submission][:language], code: params[:submission][:code], url_code: params[:submission][:file])
  	
  	if @submission.save
      @submission.verdict = get_verdict( )
      @submission.save
  		redirect_to ok_path
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

  def get_data_url( path )
    url = URI.parse( path )
    data = ""
    open( url ) do |http|
      data = http.read
    end
    return data
  end

  def test_program( code, input, output )
    submission = HTTParty.post(
      "http://api.judge0.com/submissions/", 
      :body => {
        :source_code => code,
        :language_id => 5,
        :input => input,
        :expected_output => output
      }.to_json,
      :headers => { 
        'Content-Type' => 'application/json' 
      } )
    json_submission = JSON.parse(submission.body)
    r = "In Queue"
    while r.eql? "In Queue"
      verdict = HTTParty.get( "http://api.judge0.com/submissions/"+json_submission['id'].to_s )
      json_verdict = JSON.parse(verdict.body)
      r = json_verdict['status']['description']
    end
    return r
  end
  
  def get_verdict( )
    problem = Problem.find_by( id: @submission.problem_id )
    ok = true
    problem.test_cases.each do |test_case|
      result = test_program( get_data_url( @submission.url_code.url ), get_data_url(test_case.url_input.url), get_data_url(test_case.url_output.url) )
      puts "//////////////////////////////////////////////////////////////////////////////////"
      puts result
      if result.eql? "Accepted"
        ok = ok
      else 
        ok = false
      end
    end
    if ok 
      return "Accepted"
    else
      return "Wrong"
    end
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
