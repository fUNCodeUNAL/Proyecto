class UserController < ApplicationController

  before_action :init_pagination, only: [ :paginate ]

  def paginate  
    maxQuery = 2
    userStartId = params[:pageIdUser].to_i*maxQuery

    @users = User.where("lower(username) LIKE ?", "%#{params[:search].downcase}%").offset(userStartId).limit(maxQuery).order( params[:order] )
    @usersTotal = User.where("lower(username) LIKE ?", "%#{params[:search].downcase}%").count

    if userStartId+maxQuery >= @usersTotal
      @disableUserNextButton = " disabled"
    end
    if userStartId == 0
      @disableUserPrevButton = " disabled"
    end
  end

  private

  def init_pagination
    @disableUserPrevButton = ""
    @disableUserNextButton = ""

    @send_order ={
      'username' => "DESC",
      'full_name' => "DESC",
      'email' => "DESC"
    }
    @icon_order ={
      'username' => "",
      'full_name' => "",
      'email' => ""
    }

    if params.has_key?( :order ) and params[:order].split[1].eql?"DESC"
      field = params[:order].split[0]
      @send_order[ field ] = "ASC"
      @icon_order[ field ] = "-alt"
    end
  end
	
end
