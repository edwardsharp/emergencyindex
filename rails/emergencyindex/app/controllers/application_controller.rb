class ApplicationController < ActionController::Base
  include Pundit
  protect_from_forgery with: :exception

  before_action :configure_permitted_parameters, if: :devise_controller?

  protected
  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:name, :phone, :postal])
    devise_parameter_sanitizer.permit(:account_update, keys: [:name, :phone, :postal])
  end

  def render_403
    render file: "#{Rails.root}/public/403.html",  status: :not_found
  end

end
