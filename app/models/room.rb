class Room < ApplicationRecord
  has_many :classrooms

  validates :name, presence: true
  validates :capacity, numericality: { greater_than: 0, only_integer: true }, allow_nil: true

  scope :not_archived, -> { where(is_archived: [ false, nil ]) }
end
