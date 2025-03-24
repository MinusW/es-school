class UsersController < ApplicationController
  before_action :authenticate_user!

  def index
    authorize User  # Authorize for index action explicitly
    @users = policy_scope(User)
  end

  def show
    @user = User.find(params[:id])
    authorize @user
  end

  def new
    @user = User.new
    authorize @user
  end

  def create
    @user = User.new(user_params)
    authorize @user
    if @user.save
      redirect_to @user, notice: "User created successfully."
    else
      render :new
    end
  end

  def edit
    @user = User.find(params[:id])
    authorize @user
  end

  def update
    @user = User.find(params[:id])
    authorize @user
    if @user.update(user_params)
      redirect_to @user, notice: "User updated successfully."
    else
      render :edit
    end
  end

  def destroy
    @user = User.find(params[:id])
    authorize @user
    @user.update(is_archived: true) # Instead of deleting
    redirect_to users_path, notice: "User archived successfully."
  end

  private

  def user_params
    params.require(:user).permit(:email, :password, :password_confirmation, :address_id, role_ids: [])
  end
end
