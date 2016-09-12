class RegistrationsController < Devise::RegistrationsController

  def create
  	super
    #By default creates both a student and a teacher with the same email.
    #just for testing

  	@student = Student.create( email: params[:user][:email])
    @teacher = Teacher.create( email: params[:user][:email])
  end

  private

  def sign_up_params
    params.require(:user).permit(:full_name, :email, :password, :password_confirmation)
  end

  def account_update_params
    params.require(:user).permit(:full_name, :email, :password, :password_confirmation, :current_password)
  end
end