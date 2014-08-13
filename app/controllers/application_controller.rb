class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  before_action :configure_permitted_parameters, if: :devise_controller?

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.for(:sign_up) do |u|
       u.permit(:email,:user_id, :password,:password_confirmation,
                :address,:city,:state,:country,
                 :bday,:full_name,:login,:zip,:latitude,:longitude )
    end
    devise_parameter_sanitizer.for(:account_update) do |u|
       u.permit(:email,:user_id,:password,:password_confirmation,
                 :address,:city,:state,:country,
                 :bday,:full_name,:login,:zip,:latitude,:longitude )
    end
  end
end
