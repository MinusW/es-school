class Classroom < ApplicationRecord
  belongs_to :teacher, class_name: "Teacher"
  belongs_to :class_type
  belongs_to :room
  belongs_to :quarter, optional: true

  has_many :students
  has_many :users, through: :students
  has_many :courses

  validates :name, presence: true
  validates :teacher_id, presence: true

  scope :not_archived, -> { where(is_archived: [ false, nil ]) }
end
