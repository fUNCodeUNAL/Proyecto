class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception


  # Manage the exception throw by CanCan
  rescue_from CanCan::AccessDenied do |exception|
  	# English error:
    # redirect_to root_url, :alert => exception.message
    # Snapnish error:
    redirect_to root_url, :alert => "Usted no esta autorizado para acceder a esta pagina"
  end
 
end
