class ProblemController < ApplicationController
  before_action :authenticate_user!, only: [ :create, :edit, :new ]
  def show
    @problem = Problem.find(params[:id])
  end
  
  def new
    @problem = Problem.new
  end
  
  def create
    languages = 0
    unless params[:cpp].nil?
      languages |= (1<<0)
    end
    unless params[:java].nil?
      languages |= (1<<1)
    end
    unless params[:python].nil?
      languages |= (1<<2)
    end
    @problem = Problem.new(name: params[:problem][:name], time_limit: params[:problem][:time_limit], languages: languages)
    if @problem.save
      redirect_to @problem
    else
      render :new
    end
  end

  def edit
    @problem = Problem.find(params[:id])
  end
  
  private
  
  def problem_params
    params.require(:problem).permit(:name, :time_limit, :languages)
  end
end
