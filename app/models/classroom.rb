class Classroom < ApplicationRecord
  belongs_to :teacher
  belongs_to :class_type
  belongs_to :room

  has_many :students
  has_many :users, through: :students

  validates :name, presence: true
  validates :teacher_id, presence: true

  scope :not_archived, -> { where(is_archived: [ false, nil ]) }
end
