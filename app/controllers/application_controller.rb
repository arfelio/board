class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  rescue_from CanCan::AccessDenied do |exception|
    redirect_to advertisements_url, :alert => exception.message
  end
  before_action :configure_permitted_parameters, if: :devise_controller?

  protected

  PROFILE_KEYS = [:user_id, :address, :city, :state, :country, :bday,
                  :full_name, :login, :zip, :latitude, :longitude].freeze

  # Devise 4 permits email/password/password_confirmation by default; add the profile
  # fields. RegistrationsController#update does not check current_password, so keep
  # it out of the permitted params as before.
  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: PROFILE_KEYS)
    devise_parameter_sanitizer.permit(:account_update, keys: PROFILE_KEYS, except: [:current_password])
  end
end
