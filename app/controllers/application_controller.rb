require 'authentication'

class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  include Authentication
  rescue_from CanCan::AccessDenied do |exception|
    flash[:danger] = exception.message
    redirect_to root_url
  end
end
