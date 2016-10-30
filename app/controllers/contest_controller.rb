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
		@contest.start_date = Time.new + 6*60
		@contest.end_date = Time.new + 6*60
	end

	def create
		@contest = Contest.new(contest_params)
		if @contest.save
    		redirect_to contest_index_path
    	else
    		@contest.start_date = Time.new + 6*60
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
		# Si se pudo modificar la fecha, es porque no estaba bloqueada, y por ende, hay que ejecutar
		# la validacion, se asume que ya la fecha que estaba es valida porque estamos en un update
		# esta variable se salta la validacion de la fecha inicial cuando el contest 
		# haya empezado
		@contest.contest_running = params[:contest][:"start_date(1i)"] == nil

		tmp_date = @contest.start_date
		@contest.attributes = contest_params		

	    if @contest.save
    		redirect_to contest_path(@contest.id)	
	    else
	    	@contest.start_date = tmp_date
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
end
