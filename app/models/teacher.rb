class Teacher < ApplicationRecord
  belongs_to :user

  enum :state, { active: 0, on_leave: 1, retired: 2, inactive: 3 }

  validates :user_id, presence: true, uniqueness: true
  validates :IBAN, presence: true

  scope :not_archived, -> { where(is_archived: [ false, nil ]) }

  after_create :assign_teacher_role

  has_many :classrooms
  has_many :courses
  has_many :grades

  def archive!
    ActiveRecord::Base.transaction do
      # First archive all grades
      grades.not_archived.each do |grade|
        grade.update!(is_archived: true)
      end

      # Then archive all courses
      courses.not_archived.each do |course|
        course.update!(is_archived: true)
      end

      # Then archive all classrooms
      classrooms.not_archived.each do |classroom|
        classroom.update!(is_archived: true)
      end
      
      # Finally archive the teacher
      update!(is_archived: true)
    end
  end

  private

  def assign_teacher_role
    user.add_role(:teacher) unless user.has_role?(:teacher)
    user.add_role(:dean) if is_dean
  end
end
