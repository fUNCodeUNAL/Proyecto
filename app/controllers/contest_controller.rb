class ContestController < ApplicationController
	before_action :authenticate_user!, except: [ :show, :index ]
	def index
		@contests = Contest.all
	end

	def show
		@contest = Contest.find(params[:id])
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
		@pageId = 0
	end

	def update
		
	end

	private
 	def contest_params
    	params.require(:contest).permit(:name, :teacher_id, :start_date, :end_date)
  	end
end
