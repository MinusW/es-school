class ClassroomsController < ApplicationController
  before_action :authenticate_user!
  before_action :authorize_classroom, except: [ :index, :show, :calendar, :promote ]  # Only allow authorized actions
  before_action :set_classroom, only: [:show, :edit, :update, :destroy, :calendar, :promote]

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

  def promote
    authorize @classroom, :promote?
    
    if params[:new_classroom_id].blank?
      redirect_to @classroom, alert: "Please select a new classroom."
      return
    end
    
    new_classroom = Classroom.find_by(id: params[:new_classroom_id])
    
    if new_classroom.nil?
      redirect_to @classroom, alert: "The selected classroom could not be found."
      return
    end

    # Initialize counters for the notification
    promoted_count = 0
    retained_count = 0

    # Process each student
    @classroom.students.not_archived.each do |student|
      # Calculate the student's average grade
      average_grade = student.grades.not_archived.average(:grade)&.round(2) || 0
      
      # Only promote students with average grade of 4 or higher
      if average_grade >= 4
        student.update(classroom: new_classroom)
        promoted_count += 1
      else
        # Students with average below 4 stay in the current classroom
        retained_count += 1
      end
    end

    # Create a detailed notification message
    message = "Class promotion completed: #{promoted_count} students promoted"
    message += " and #{retained_count} students retained due to grades below 4.0." if retained_count > 0

    redirect_to @classroom, notice: message
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
