class ContestController < ApplicationController
	before_action :authenticate_user!, except: [ :show, :index ]

	helper_method :calculate_score, :count_submissions, :count_accepted

	def index
		@contests = Contest.all
	end

	def show
		@contest = Contest.find(params[:id])
		@problemsIn = @contest.problem_contest_relationships
		@registeredUsers = @contest.users
	end

	def register 
		UserContestRelationship.create(register_params)
		redirect_to contest_path(params[:contest_id])
	end

	def new
		@teacher_id = current_user.id
		@contest = Contest.new
	end

	def create
		@contest = Contest.new(contest_params)
		if @contest.save
    		redirect_to contest_index_path
    	else
    		render :new
    	end
	end
	
	def edit
		@contest = Contest.find(params[:id])
		@teacher_id = current_user.id
		@problemsIn = @contest.problem_contest_relationships
	end

	def update
		@contest = Contest.find(params[:id])
	    if @contest.update(contest_params)
	    	redirect_to contest_path(@contest.id)	
	    else
	    	render :edit
	    end
	end

	def add_problem
		@contest = Contest.find(params[:contest_id])
		@problemsIn = @contest.problem_contest_relationships
		ProblemContestRelationship.create(contest_id: params[:contest_id], problem_id: params[:problem_id], score: 1)
	end

	def delete_problem
		@contest = Contest.find(params[:contest_id])
		@problemsIn = @contest.problem_contest_relationships
		ProblemContestRelationship.delete(params[:problem_index])
	end

	def update_problem
		@contest = Contest.find(params[:contest_id])
		@problemsIn = @contest.problem_contest_relationships
		record = ProblemContestRelationship.find(params[:problem_index])
		if !record.update(score: params[:score])
			render :edit
		end
	end

	private
 	def contest_params
    	params.require(:contest).permit(:name, :teacher_id, :start_date, :end_date)
  	end
  	def register_params
    	params.permit(:contest_id, :user_id)
  	end

  	# Return the maximum number of test cases passed by a submission made in a contest by an user
  	def count_accepted(user_id, problem_id)
  		submissionsInContest = Submission.where("user_id = ? AND problem_id = ? AND created_at > ? AND created_at < ?", user_id, problem_id, @contest.start_date, @contest.end_date)
  		count = 0
  		# The method to_i in ruby parse to integer every number from the start of the string
  		# If there isn't any, return 0
  		submissionsInContest.each do |s|
  			count = [count, s.verdict.to_i ].max
  		end
  		return count
  	end

  	def calculate_score(user_id)
  		count = 0
  		@problemsIn.each do |r|
  			tmp = count_accepted(user_id, r.problem.id)
  			count = count + r.score * tmp
  		end
  		return count
  	end

  	# Return the number of submissions made for a user in a contest
  	def count_submissions(user_id, problem_id)
  		Submission.where("user_id = ? AND problem_id = ? AND created_at > ? AND created_at < ? ", user_id, problem_id, @contest.start_date, @contest.end_date).count
  	end
end
