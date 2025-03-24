class Theme < ApplicationRecord
  has_many :courses, foreign_key: "theme_id"

  validates :module_name, presence: true

  scope :not_archived, -> { where(is_archived: [ false, nil ]) }
end
