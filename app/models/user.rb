class User < ApplicationRecord
  rolify
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :students
  has_many :classrooms, through: :students
  has_many :courses, foreign_key: "teacher_id"
  has_many :grades, foreign_key: "teacher_id"
  has_many :student_grades, through: :students, source: :grades
  belongs_to :address, optional: true
  has_one :teacher, dependent: :destroy

  validates :first_name, presence: true
  validates :last_name, presence: true

  attr_accessor :role_id

  before_save :assign_role

  def full_name
    "#{first_name} #{last_name}"
  end

  def dean?
    has_role?(:dean)
  end

  def teacher?
    has_role?(:teacher)
  end

  def student?
    has_role?(:student)
  end

  private

  def assign_role
    return if role_id.blank?

    # Remove all existing roles
    roles.clear

    # Add the new role
    role = Role.find(role_id)
    add_role(role.name)
  end
end
