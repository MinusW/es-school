class StudentsController < ApplicationController
  before_action :set_student, only: %i[ show edit update destroy generate_pdf ]
  before_action :authenticate_user!
  before_action :authorize_student, only: [ :show, :generate_pdf ]

  # GET /students or /students.json
  def index
    @students = policy_scope(Student)
  end

  # GET /students/1 or /students/1.json
  def show
    authorize @student
  end

  # GET /students/new
  def new
    @student = Student.new
    authorize @student
  end

  # GET /students/1/edit
  def edit
    authorize @student
  end

  # POST /students or /students.json
  def create
    @student = Student.new(student_params)
    authorize @student

    # Create new user
    user = User.new(
      first_name: params[:student][:first_name],
      last_name: params[:student][:last_name],
      email: params[:student][:email],
      phone: params[:student][:phone],
      password: params[:student][:password],
      password_confirmation: params[:student][:password_confirmation],
      address_id: params[:student][:user][:address_id]
    )
    user.add_role(:student)
    user.save!
    @student.user = user

    respond_to do |format|
      if @student.save
        format.html { redirect_to student_url(@student), notice: "Student was successfully created." }
        format.json { render :show, status: :created, location: @student }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @student.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /students/1 or /students/1.json
  def update
    authorize @student

    respond_to do |format|
      if @student.update(student_params)
        format.html { redirect_to student_url(@student), notice: "Student was successfully updated." }
        format.json { render :show, status: :ok, location: @student }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @student.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /students/1 or /students/1.json
  def destroy
    authorize @student
    @student.destroy!

    respond_to do |format|
      format.html { redirect_to students_url, notice: "Student was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  def generate_pdf
    authorize @student
    respond_to do |format|
      format.pdf do
        pdf = GradePdfGenerator.new(@student).generate
        send_data pdf.render,
                  filename: "grades_#{@student.user.full_name.parameterize}.pdf",
                  type: "application/pdf",
                  disposition: "inline"
      end
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_student
      @student = Student.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def student_params
      params.require(:student).permit(:classroom_id, :state)
    end

    def authorize_student
      unless current_user.dean? || (current_user.student? && current_user.students.include?(@student))
        flash[:alert] = "You are not authorized to view this student's grades."
        redirect_to root_path
      end
    end
end
