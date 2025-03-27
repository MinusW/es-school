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
      # Assign the selected role
      @user.add_role(params[:user][:role])
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

    # Only update password if change_password is checked
    if params[:change_password] == "1"
      if @user.update(user_params)
        redirect_to @user, notice: "User updated successfully."
      else
        render :edit
      end
    else
      # Remove password fields from params if not changing password
      params[:user].delete(:password)
      params[:user].delete(:password_confirmation)
      
      if @user.update(user_params)
        redirect_to @user, notice: "User updated successfully."
      else
        render :edit
      end
    end
  end

  def destroy
    @user = User.find(params[:id])
    authorize @user
    @user.update(is_archived: true) # Instead of deleting
    redirect_to users_path, notice: "User archived successfully."
  end

  private

  def set_user
    @user = User.find(params[:id])
  end

  def user_params
    params.require(:user).permit(:email, :password, :password_confirmation, :first_name, :last_name, :is_archived, :phone, :address_id, :role_id)
  end
end
