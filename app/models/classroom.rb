class Classroom < ApplicationRecord
  belongs_to :teacher
  belongs_to :class_type
  belongs_to :room

  validates :name, presence: true
  validates :teacher_id, presence: true
end
