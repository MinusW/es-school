class ClassroomsController < ApplicationController
  before_action :authenticate_user!
  before_action :authorize_classroom, except: [ :index, :show, :calendar ]  # Only allow authorized actions
  before_action :set_classroom, only: [:show, :edit, :update, :destroy, :calendar]

  def index
    @classrooms = policy_scope(Classroom)  # Pundit scope for classrooms
  end

  def show
    authorize @classroom  # Ensure authorization for the show action
  end

  def new
    @classroom = Classroom.new
    authorize @classroom
  end

  def create
    @classroom = Classroom.new(classroom_params)
    authorize @classroom
    if @classroom.save
      redirect_to @classroom, notice: "Classroom created successfully."
    else
      render :new
    end
  end

  def edit
    authorize @classroom
  end

  def update
    authorize @classroom
    if @classroom.update(classroom_params)
      redirect_to @classroom, notice: "Classroom updated successfully."
    else
      render :edit
    end
  end

  def destroy
    authorize @classroom
    @classroom.update(is_archived: true)  # Instead of delete, archive
    redirect_to classrooms_path, notice: "Classroom archived successfully."
  end

  def calendar
    authorize @classroom
    @courses = @classroom.courses.not_archived.order(:weekday, :start_time)
  end

  private

  def classroom_params
    params.require(:classroom).permit(:name, :class_type_id, :room_id, :teacher_id, :quarter_id, :is_archived)
  end

  def authorize_classroom
    authorize Classroom  # Ensure this is authorized with Pundit
  end

  def set_classroom
    @classroom = Classroom.find(params[:id])
  end
end
