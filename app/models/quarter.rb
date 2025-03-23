class Quarter < ApplicationRecord
  has_many :courses

  validates :name, :start_date, :end_date, presence: true
  validate :end_date_after_start_date

  scope :not_archived, -> { where(is_archived: [ false, nil ]) }

  private

  def end_date_after_start_date
    if start_date.present? && end_date.present? && end_date <= start_date
      errors.add(:end_date, "must be after start date")
    end
  end
end
