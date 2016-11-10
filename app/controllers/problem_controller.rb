require 'zip'

class ProblemController < ApplicationController
  before_action :authenticate_user!, only: [ :create, :edit, :new ]

  def index
    @problems = Problem.all
  end

  def show
    @problem = Problem.find(params[:id])
    @available_languages = get_list_languages( @problem.languages )
  end
  
  def new
    @problem = Problem.new
  end
  
  def create
    #NOTA: Los @problem.save que se llaman cuando hay errores es para que no reinicie el formulario y muestre que errores hubieron
    @problem = Problem.new
    if params[:problem][:file] != nil and params[:problem][:file].headers.include? ".zip"
      total_pdf = count_pdf_files(params)
      total_test_cases = count_test_cases(params)
      if total_test_cases == 0 or total_pdf != 1 or not create_problem(params)
        @problem.save
        render :new
      else 
        add_test_cases(params)
        redirect_to @problem
      end
    else
      @problem.save
      render :new
    end
  end

  def edit
    @problem = Problem.find(params[:id])
    @available_languages = get_list_languages( @problem.languages )
  end

  def update
    @problem = Problem.find(params[:id])
    @problem.update( {name: params[:problem][:name]})
    @problem.update( {time_limit: params[:problem][:time_limit]})
    @problem.update( {languages: get_languages( params ) })

    if params[:problem][:pdf] != nil and params[:problem][:pdf].headers.include? ".pdf"
      @problem.update( {url_statement: params[:problem][:pdf] })
    end

    if params[:problem][:file] != nil and params[:problem][:file].headers.include? ".zip"
      total_test_cases = count_test_cases(params)
      if total_test_cases == 0
        render :edit
      else 
        add_test_cases(params)
      end
    else
      render :edit
    end

    redirect_to @problem
  end

  def delete_test_case
    @record = Problem.find( params[:problem_id] ).test_cases[ params[:test_idx].to_i ]
    @record.destroy
    redirect_to problem_edit_path(params[:problem_id])
  end

  def search
    maxQuery = 2
    @disablePrevButton = ""
    @disableNextButton = ""
    problemStartId = params[:pageId].to_i*maxQuery
    @send_order ={
      id: "DESC",
      name: "DESC",
      created_at: "DESC"
    }
    @icon_order ={
      id: "",
      name: "",
      created_at: ""
    }
    
    if( is_number?( params[:search] ) )
      @problems = Problem.where("id = ? or lower(name) LIKE ?", Integer("#{params[:search]}"), "%#{params[:search].downcase}%").offset(problemStartId).limit(maxQuery).order(params[:order])
      @problemTotal = Problem.where("id = ? or lower(name) LIKE ?", Integer("#{params[:search]}"), "%#{params[:search].downcase}%").count
    else
      @problems = Problem.where("lower(name) LIKE ?", "%#{params[:search].downcase}%").offset(problemStartId).limit(maxQuery).order(params[:order])
      @problemTotal = Problem.where("lower(name) LIKE ?", "%#{params[:search].downcase}%").count
    end

    if problemStartId+maxQuery >= @problemTotal
      @disableNextButton = " disabled"
    end
    if problemStartId == 0
      @disablePrevButton = " disabled"
    end
    
    case params[:order]
    when "id DESC"
      @send_order[:id] = "ASC"
      @icon_order[:id] = "-alt"
    when "name DESC"
      @send_order[:name] = "ASC"
      @icon_order[:name] = "-alt"
    when "created_at DESC"
      @send_order[:created_at] = "ASC"
      @icon_order[:created_at] = "-alt"
    end
  end

  def rejudge
    problem = Problem.find(params[:id])
    judge = JudgeApi.new
    problem.submissions.each do |submission|
      submission.verdict = 'Pending'
      submission.execution_time = '-'
      submission.api_ids = judge.sendSubmission(submission)
      submission.in_queue = false
      submission.save
    end
    redirect_to submissions_problem_path(params[:id])
  end

  private

  def create_temporary_file(file)
    filename = file.name
    basename = File.basename(filename)
    tmp = Tempfile.new(basename)
    tmp.binmode
    tmp.write file.get_input_stream.read
    tmp.close
    return tmp.path
  end

  def add_test_cases(params)
    Zip::File.open(params[:problem][:file].tempfile) do |zip_file|
      zip_file.each do |file_1|
        if file_1.name.include? ".in"
          basename_file_1 = File.basename( file_1.name, ".in" )
          zip_file.each do |file_2|
            if file_2.name.include? ".out"
              basename_file_2 = File.basename( file_2.name, ".out" )
              if basename_file_1.eql? basename_file_2
                path_file_1 = create_temporary_file(file_1)
                path_file_2 = create_temporary_file(file_2)
                @problem.test_cases.create(url_input: File.open(path_file_1), url_output: File.open(path_file_2))
              end
            end
          end
        end
      end
    end
  end

  def create_problem(params)
    languages = get_languages(params)
    @problem = Problem.new
    @problem.name = params[:problem][:name]
    @problem.time_limit = params[:problem][:time_limit]
    @problem.languages = languages
    Zip::File.open(params[:problem][:file].tempfile) do |zip_file|
      zip_file.each do |file|
        if file.name.include? ".pdf"
          path_file = create_temporary_file(file)
          @problem.url_statement = File.open(path_file)
          break
        end
      end
    end
    unless @problem.save
      return false
    end
    return true
  end

  def count_pdf_files(params)
    cnt = 0
    Zip::File.open(params[:problem][:file].tempfile) do |zip_file|
      zip_file.each do |file|
        if file.name.include? ".pdf"
          cnt = cnt+1
        end
      end
    end
    return cnt
  end

  def count_test_cases(params) 
    cnt = 0
    Zip::File.open(params[:problem][:file].tempfile) do |zip_file|
      zip_file.each do |file_1|
        if file_1.name.include? ".in"
          basename_file_1 = File.basename( file_1.name, ".in" )
          zip_file.each do |file_2|
            if file_2.name.include? ".out"
              basename_file_2 = File.basename( file_2.name, ".out" )
              if basename_file_1.eql? basename_file_2
                cnt = cnt+1
                break
              end
            end
          end
        end
      end
    end
    return cnt
  end

  def get_languages(params)
    languages = 0
    unless params[:cpp].nil?
      languages |= (1<<0)
    end
    unless params[:java].nil?
      languages |= (1<<1)
    end
    unless params[:py].nil?
      languages |= (1<<2)
    end
    unless params[:c].nil?
      languages |= (1<<3)
    end
    return languages
  end

  def get_list_languages( languages )
    array = []
    array.push([ 'cpp', 'C++', ( languages>>0 )&1 ])
    array.push([ 'java', 'Java', ( languages>>1 )&1 ])
    array.push([ 'py', 'Python', ( languages>>2 )&1 ])
    array.push([ 'c', 'C', ( languages>>3 )&1 ])
    return array
  end 
  
  def problem_params
    params.require(:problem).permit(:name, :time_limit)
  end

  def is_number? string
    true if Integer(string) rescue false
  end
end
