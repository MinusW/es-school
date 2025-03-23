class ApplicationController < ActionController::Base
  include Pundit
  allow_browser versions: :modern

  before_action :authenticate_user!
  after_action :verify_authorized, except: :index
  after_action :verify_policy_scoped, only: :index

  # Skip Pundit checks for Devise controllers as they don't use Pundit
  skip_after_action :verify_authorized, :verify_policy_scoped, if: :devise_controller?

  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized

  private

  def user_not_authorized
    flash[:alert] = "You are not authorized to perform this action."
    redirect_to(request.referer || root_path)
  end
end
