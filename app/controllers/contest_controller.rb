class ContestController < ApplicationController
	before_action :authenticate_user!, except: [ :show, :index ]
	before_action :init_pagination, only: [ :index, :paginate ]
	
	
	def index

		maxQuery = 10
		@cur_date = Time.new
		@past_contest = Contest.where("end_date < ? ", @cur_date).limit(maxQuery)
		@past_contest_total = Contest.where("end_date < ? ", @cur_date).count
		@comming_contest = Contest.where("start_date > ? ", @cur_date).limit(maxQuery)
		@comming_contest_total = Contest.where("start_date > ? ", @cur_date).count
		@running_contest = Contest.where("start_date <= ? AND end_date >= ? ", @cur_date, @cur_date).limit(maxQuery)
		@running_contest_total = Contest.where("start_date <= ? AND end_date >= ? ", @cur_date, @cur_date).count

		@disablePrevButton = { 'Past' => ' disabled',
								'Comming' => ' disabled',
								'Running' => ' disabled' }

		if @past_contest_total <= maxQuery
			@disableNextButton['Past'] = " disabled"
		end
		if @comming_contest_total <= maxQuery
			@disableNextButton['Comming'] = " disabled"
		end
		if @running_contest_total <= maxQuery
			@disableNextButton['Running'] = " disabled"
		end

	end

	def paginate
		maxQuery = 10
		contestStartId = params['pageId' + params[:type]].to_i*maxQuery

		cur_date = params[:cur_date].to_datetime
		if( params[:type].eql?('Past') )
			@contests = Contest.where("end_date < ? ", cur_date).offset(contestStartId).limit(maxQuery).order(params[:order])
			@contests_total = Contest.where("end_date < ? ", cur_date).count
		elsif( params[:type].eql?('Comming') )
			@contests = Contest.where("start_date > ? ", cur_date).offset(contestStartId).limit(maxQuery).order(params[:order])
			@contests_total = Contest.where("start_date > ? ", cur_date).count
		else
			@contests = Contest.where("start_date <= ? AND end_date >= ? ", cur_date, cur_date).offset(contestStartId).limit(maxQuery).order(params[:order])
			@contests_total = Contest.where("start_date <= ? AND end_date >= ? ", cur_date, cur_date).count
		end

		if contestStartId+maxQuery >= @contests_total
			@disableNextButton[ params[:type] ] = " disabled"
		end
		if contestStartId == 0
			@disablePrevButton[ params[:type] ] = " disabled"
		end
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

	def init_pagination
		types = ['Past', 'Running', 'Comming']

		@disablePrevButton ||= {}
		@disableNextButton ||= {}
		@send_order ||= {}
		@icon_order ||= {}
		types.each do |type|
			@disablePrevButton[ type ] = ''
			@disableNextButton[ type ] = ''
			@send_order[ type ] = {
				'id' => 'DESC',
				'name' => 'DESC',
				'start_date' => 'DESC',
				'end_date' => 'DESC'
			}
			@icon_order[ type ] = {
				'id' => '',
				'name' => '',
				'start_date' => '',
				'end_date' => ''
			}
		end

		if params.has_key?( :order ) and params[:order].split[1].eql?"DESC"
			field = params[:order].split[0]
			@send_order[params[:type]][ field ] = "ASC"
			@icon_order[params[:type]][ field ] = "-alt"
		end
	end

 	def contest_params
    	params.require(:contest).permit(:name, :teacher_id, :start_date, :end_date)
  	end
end
