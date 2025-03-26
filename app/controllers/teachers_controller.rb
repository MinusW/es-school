class TeachersController < ApplicationController
  before_action :set_teacher, only: %i[ show edit update destroy ]
  before_action :authenticate_user!

  # GET /teachers or /teachers.json
  def index
    @teachers = policy_scope(Teacher)
  end

  # GET /teachers/1 or /teachers/1.json
  def show
    authorize @teacher
  end

  # GET /teachers/new
  def new
    @teacher = Teacher.new
    authorize @teacher
  end

  # GET /teachers/1/edit
  def edit
    authorize @teacher
  end

  # POST /teachers or /teachers.json
  def create
    @teacher = Teacher.new(teacher_params)
    authorize @teacher

    # Create new user
    user = User.new(
      first_name: params[:teacher][:first_name],
      last_name: params[:teacher][:last_name],
      email: params[:teacher][:email],
      phone: params[:teacher][:phone],
      password: params[:teacher][:password],
      password_confirmation: params[:teacher][:password_confirmation]
    )
    user.add_role(:teacher)
    user.save!
    @teacher.user = user

    respond_to do |format|
      if @teacher.save
        format.html { redirect_to teacher_url(@teacher), notice: "Teacher was successfully created." }
        format.json { render :show, status: :created, location: @teacher }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @teacher.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /teachers/1 or /teachers/1.json
  def update
    authorize @teacher

    respond_to do |format|
      if @teacher.update(teacher_params)
        format.html { redirect_to teacher_url(@teacher), notice: "Teacher was successfully updated." }
        format.json { render :show, status: :ok, location: @teacher }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @teacher.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /teachers/1 or /teachers/1.json
  def destroy
    authorize @teacher
    @teacher.destroy!

    respond_to do |format|
      format.html { redirect_to teachers_url, notice: "Teacher was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  def calendar
    authorize @teacher
    @courses = @teacher.courses.not_archived.order(:weekday, :start_time)
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_teacher
      @teacher = Teacher.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def teacher_params
      params.require(:teacher).permit(:address_id)
    end
end
