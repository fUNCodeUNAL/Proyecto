class UserController < ApplicationController
  
  def new
    @user = User.new
  end
  def create
    render :new
=begin
    @user = User.new(user_params)
    #@user.email = @user.email.downcase
    @user.email = @user.email+"@unal.edu.co"
    #Se asume que si se pasa la validaciónde user también pasa la de student.
    #Los atributos cod y semester de student no son obligatorios aún.
    if @user.save
      @student = Student.create( email: params[:user][:email] )
      redirect_to root_path
    else
      render :new
    end
=end
  end

  private

  def user_params
      params.require(:user).permit(:full_name, :email, :password, :password_confirmation)
  end

end
