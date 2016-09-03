class UserController < ApplicationController
  
  def new
    @user = User.new
  end
  def create
    @user = User.new(user_params)
    @user.email = @user.email.downcase
    if @user.save
      redirect_to root_path
    else
      render :new
    end
  end

  private

  def user_params
      params.require(:user).permit(:full_name, :email, :email_confirmation, :password, :password_confirmation)
    end

end
