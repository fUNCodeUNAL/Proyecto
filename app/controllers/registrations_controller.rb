class RegistrationsController < Devise::RegistrationsController

  def create
  	super
    #By default creates both a student and a teacher with the same email.
    #just for testing
    if User.find_by(username: params[:user][:username]) != nil
      @student = Student.create(username: params[:user][:username])
      # If you want to add a Teacher:
      # In your browser go to '/new_teacher' and write the username of an existent student
      # It must be done with and existent teacher account.
      # If not, make sure you only create either a teacher or a student
      # @teacher = Teacher.create(username: params[:user][:username])
    end

  end

  private

  def sign_up_params
    params.require(:user).permit(:full_name, :username, :email, :password, :password_confirmation)
  end

  def account_update_params
    # it seems weird because email...
    params.require(:user).permit(:full_name, :username, :email, :password, :password_confirmation, :current_password)
  end
end