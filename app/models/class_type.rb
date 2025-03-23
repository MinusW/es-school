class ClassType < ApplicationRecord
  has_many :classrooms

  validates :name, presence: true, uniqueness: true

  scope :not_archived, -> { where(is_archived: [ false, nil ]) }
end
