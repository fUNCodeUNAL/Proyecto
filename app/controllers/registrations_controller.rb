class RegistrationsController < Devise::RegistrationsController

  def check_error(param)
    if @user.errors.include?(param) 
      @error_class = " has-error"
      @error = "*" + @user.errors.full_messages_for(param)[0]
    else 
      @error = ""
      @error_class = ""
    end
  end

  def create
  	super
    #By default creates both a student and a teacher with the same email.
    #just for testing

    if User.find_by(username: params[:user][:username]) != nil
      @student = Student.create(username: params[:user][:username])
      @teacher = Teacher.create(username: params[:user][:username])
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