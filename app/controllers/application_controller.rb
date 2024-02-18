class ApplicationController < ActionController::API
  before_action :configure_permitted_parameters, if: :devise_controller?
  before_action :authenticate_api_v1_user!

  protected

  def current_ability
    @current_ability ||= Ability.new(current_api_v1_user)
  end

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: %i[name email password password_confirmation])
  end
end
