class CourseModule < ApplicationRecord
  has_many :courses, foreign_key: "theme_id"

  validates :name, presence: true

  scope :not_archived, -> { where(is_archived: [ false, nil ]) }
end
