class User < ApplicationRecord
  rolify
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :students
  has_many :classrooms, through: :students
  has_many :courses, foreign_key: "teacher_id"

  def dean?
    has_role?(:dean)
  end

  def teacher?
    has_role?(:teacher)
  end

  def student?
    has_role?(:student)
  end
end
