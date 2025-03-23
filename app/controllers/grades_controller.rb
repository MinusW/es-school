class GradesController < ApplicationController
  before_action :set_grade, only: %i[ show edit update destroy ]

  # GET /grades or /grades.json
  def index
    @grades = policy_scope(Grade)
  end

  # GET /grades/1 or /grades/1.json
  def show
    authorize @grade
  end

  # GET /grades/new
  def new
    @grade = Grade.new
    authorize @grade
    # Set the teacher to the current user if they are a teacher
    @grade.teacher_id = current_user.id if current_user.teacher?
  end

  # GET /grades/1/edit
  def edit
    authorize @grade
  end

  # POST /grades or /grades.json
  def create
    @grade = Grade.new(grade_params)
    @grade.teacher_id = current_user.id if current_user.teacher?
    authorize @grade

    respond_to do |format|
      if @grade.save
        format.html { redirect_to grade_url(@grade), notice: "Grade was successfully created." }
        format.json { render :show, status: :created, location: @grade }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @grade.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /grades/1 or /grades/1.json
  def update
    authorize @grade

    respond_to do |format|
      if @grade.update(grade_params)
        format.html { redirect_to grade_url(@grade), notice: "Grade was successfully updated." }
        format.json { render :show, status: :ok, location: @grade }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @grade.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /grades/1 or /grades/1.json
  def destroy
    authorize @grade

    # Soft delete - just mark as archived instead of destroying
    @grade.update(is_archived: true)

    respond_to do |format|
      format.html { redirect_to grades_url, notice: "Grade was successfully archived." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_grade
      @grade = Grade.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def grade_params
      # Don't allow teacher_id to be changed in params
      if current_user.teacher?
        params.require(:grade).permit(:student_id, :course_id, :grade, :grading_date)
      else
        params.require(:grade).permit(:student_id, :teacher_id, :course_id, :grade, :grading_date, :is_archived)
      end
    end
end
