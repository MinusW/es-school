class Grade < ApplicationRecord
  belongs_to :student
  belongs_to :teacher, class_name: "Teacher"
  belongs_to :course

  validates :grade, presence: true, numericality: { greater_than_or_equal_to: 0.0, less_than_or_equal_to: 20.0 }
  validates :grading_date, presence: true

  scope :not_archived, -> { where(is_archived: [ false, nil ]) }
end
