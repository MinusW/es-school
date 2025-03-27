class Quarter < ApplicationRecord
  has_many :classrooms, dependent: :restrict_with_error
  has_many :courses, through: :classrooms

  validates :name, presence: true
  validates :start_date, presence: true
  validates :end_date, presence: true
  validate :end_date_after_start_date

  scope :not_archived, -> { where(is_archived: [false, nil]) }
  scope :archived, -> { where(is_archived: true) }

  def self.current
    not_archived.where('start_date <= ? AND end_date >= ?', Date.current, Date.current).first
  end

  private

  def end_date_after_start_date
    return if end_date.blank? || start_date.blank?

    if end_date < start_date
      errors.add(:end_date, "must be after start date")
    end
  end
end
