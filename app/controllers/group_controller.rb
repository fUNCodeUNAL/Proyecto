class GroupController < ApplicationController

  before_action :authenticate_user!
  def create
    @group = Group.create(group_params)
    redirect_to teacher_groups_show_path
  end
  def destroy
    @group = Group.find(params[:id])
    @group.destroy
    redirect_to teacher_groups_show_path
  end
  def edit
    @group = Group.find(params[:id_group])
  end
  def delete_student
    @record = HasGroup.find_by( group_id: params[:id_group], student_id: params[:id_student] )
    @record.destroy
    redirect_to teacher_groups_edit_path(params[:id_group])
  end
  def add_student
    emails = has_group_params[:student_email].split("\r\n")

    notFound = ""
    emails.each do |email|
      user = User.find_by(email: email)
      if user == nil
        notFound = notFound + email + "\n"
      else
        student = Student.find_by( username: user.username )
        if student == nil
          notFound = notFound + email + "\n"
        else
          HasGroup.create(group_id: has_group_params[:id_group], student_id: student.id)
        end
      end
    end
    if notFound.length > 0
      flash[:alert] = "Error: No se encontraron los siguientes usuarios: " + notFound
    end
    redirect_to teacher_groups_edit_path(has_group_params[:id_group])
  end

  def statistics
    @contests = GroupAndContest.where( group_id: params[:id_group] )
    @name_group = Group.find(params[:id_group]).name
    @name_teacher = Teacher.find(current_user.id).username

    @name_contests = @contests.collect{ |x| Contest.find(x.contest_id).name }
    @info_student = []
    group = Group.find(params[:id_group])
    group.students.each do |x|
      tmp = [x.username]
      sum = 0
      @contests.each do |c| 
        cur = calculate_score(x.id, c.contest_id)
        tmp.push( cur )
        sum = sum + cur
      end
      tmp.insert(1, sum)
      @info_student.push(tmp)
    end

    @total_contests = [5.0]
    sum = 0
    @contests.each do |c|
      tmp = calculate_max_contest_score(c.contest_id)
      @total_contests.push(tmp)
      sum = sum + tmp
    end
    @total_contests.insert(1, sum)

    @info_student.each do |s| 
      s.insert( 1, (s.last*5.0)/sum )
    end

    render xlsx: "statistics", filename: @name_group + ".xlsx"
    
  end



  private
  def group_params
    params.require(:group).permit(:name, :teacher_id)
  end
  def has_group_params
    params.require(:info_student).permit(:student_email, :id_group)
  end

  def calculate_score(user_id, contest_id)
    count = 0

    contest = Contest.find(contest_id)
    problemsIn = contest.problem_contest_relationships
    problemsIn.each do |r|
      tmp = count_accepted(user_id, r.problem.id, contest)
      count = count + r.score * tmp
    end
    return count
  end

  def count_accepted(user_id, problem_id, contest)
      submissionsInContest = Submission.where("user_id = ? AND problem_id = ? AND created_at > ? AND created_at < ?", user_id, problem_id, contest.start_date, contest.end_date)
      count = 0
      submissionsInContest.each do |s|
        count = [count, s.verdict.to_i ].max
      end
      return count
    end

  def calculate_max_contest_score(contest_id) 
    count = 0
    problemsIn = Contest.find(contest_id).problem_contest_relationships
    problemsIn.each do |r|
      count = count + r.problem.test_cases.count * r.score
    end
    return count
  end
end
