class ApplicationController < ActionController::Base
  protect_from_forgery
  def authenticate!
    unless current_user
      redirect_to root_path
    end
  end
end
