class ContestController < ApplicationController
	load_and_authorize_resource except: [:create, :register, :update, :add_problem, :delete_problem, :update_problem]

	before_action :authenticate_user!, except: [ :show, :index ]
	before_action :init_pagination, only: [ :index, :paginate, :my_contests ]
	helper_method :calculate_score, :count_submissions, :count_accepted

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
		@problemsIn = @contest.problem_contest_relationships
		@registeredUsers = @contest.users
		# esto ordena en orden ascendente primero por el score total, y luego por la cantidad de problemas
		# entre mas score mejor, entre menos problemas mejor y luego por la cantidad de envios.
		@registeredUsers = @registeredUsers.sort_by{ |p| [-calculate_score(p.id), count_ac_problems(p.id), count_total_submissions(p.id)] }
		if current_user != nil and @contest.teacher_id == current_user.id
			@teacher_groups = Teacher.find(current_user.id).groups
		end
	end

	def register 
		UserContestRelationship.create(register_params)
		redirect_to contest_path(params[:contest_id])
	end

	def register_group
		@group_students = Group.find(params[:group_id]).students
		GroupAndContest.create(contest_id: params[:contest_id], group_id: params[:group_id])
		@group_students.each do |g|
		    UserContestRelationship.create(contest_id: params[:contest_id], user_id: Student.find_by(username: g.username).id)
		end
		redirect_to contest_path(params[:contest_id])
	end

	def new
		@teacher_id = Teacher.find_by(username: current_user.username).id
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
		@teacher_id = Teacher.find_by(username: current_user.username).id
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

	def my_contests

		maxQuery = 10
		@cur_date = Time.new

		teacher_id = Teacher.find_by(username: current_user.username).id

		@past_contest = Contest.where("end_date < ? AND teacher_id = ?", @cur_date, teacher_id).limit(maxQuery)
		@past_contest_total = Contest.where("end_date < ? AND teacher_id = ?", @cur_date, teacher_id).count
		@comming_contest = Contest.where("start_date > ? AND teacher_id = ?", @cur_date, teacher_id).limit(maxQuery)
		@comming_contest_total = Contest.where("start_date > ? AND teacher_id = ?", @cur_date, teacher_id).count
		@running_contest = Contest.where("start_date <= ? AND end_date >= ? AND teacher_id = ?", @cur_date, @cur_date, teacher_id).limit(maxQuery)
		@running_contest_total = Contest.where("start_date <= ? AND end_date >= ? AND teacher_id = ?", @cur_date, @cur_date, teacher_id).count

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

  	def count_ac_problems(user_id)
  		count = 0
  		@problemsIn.each do |r|
  			if count_accepted(user_id, r.problem.id) == r.problem.test_cases.count
  				count = count + 1
  			end
  		end
  		return count
  	end

  	def count_total_submissions(user_id)
  		count = 0
  		@problemsIn.each do |r|
  			count = count + count_submissions(user_id, r.problem.id)
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
