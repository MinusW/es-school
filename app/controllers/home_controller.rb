class HomeController < ApplicationController
  # Skip authentication for the home page
  skip_before_action :authenticate_user!, only: :index
  # Skip Pundit authorization for the home page
  skip_after_action :verify_authorized, only: :index
  skip_after_action :verify_policy_scoped, only: :index

  def index
  end
end
