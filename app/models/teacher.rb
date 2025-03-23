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

  private

  def assign_teacher_role
    user.add_role(:teacher) unless user.has_role?(:teacher)
    user.add_role(:dean) if is_dean
  end
end
