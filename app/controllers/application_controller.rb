class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception


  # Manage the exception throw by CanCan
  rescue_from CanCan::AccessDenied do |exception|
  	# English error:
    # redirect_to root_url, :alert => exception.message
    # Snapnish error:
    redirect_to root_url, :alert => "Usted no esta autorizado para acceder a esta pagina"
  end

  # Error in CanCan gem
  # For more information read this: http://stackoverflow.com/questions/17335329/activemodelforbiddenattributeserror-when-creating-new-user
  before_filter do
    resource = controller_name.singularize.to_sym
    method = "#{resource}_params"
    params[resource] &&= send(method) if respond_to?(method, true)
  end
end
