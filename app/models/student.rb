class Student < ApplicationRecord
  belongs_to :user
  belongs_to :classroom

  enum :state, { active: 0, on_break: 1, expelled: 2, medical_leave: 3, graduated: 4 }

  validates :state, presence: true
  validates :user_id, uniqueness: { scope: :classroom_id, message: "is already a student in this classroom" }

  scope :not_archived, -> { where(is_archived: [ false, nil ]) }
end
