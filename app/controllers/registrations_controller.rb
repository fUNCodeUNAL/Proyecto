class RegistrationsController < Devise::RegistrationsController

  def create
  	super
  	@student = Student.create( email: params[:user][:email])
  end

  private

  def sign_up_params
    params.require(:user).permit(:full_name, :email, :password, :password_confirmation)
  end

  def account_update_params
    params.require(:user).permit(:full_name, :email, :password, :password_confirmation, :current_password)
  end
end