class Course < ApplicationRecord
  belongs_to :quarter
  belongs_to :module, class_name: "Theme"
  belongs_to :classroom
  belongs_to :teacher, class_name: "User"

  has_many :grades

  enum :weekday, { monday: 0, tuesday: 1, wednesday: 2, thursday: 3, friday: 4, saturday: 5, sunday: 6 }

  validates :start_time, :end_time, :weekday, presence: true
  validate :end_time_after_start_time
  validate :no_overlapping_courses

  scope :not_archived, -> { where(is_archived: [ false, nil ]) }

  private

  def end_time_after_start_time
    if start_time.present? && end_time.present? && end_time <= start_time
      errors.add(:end_time, "must be after start time")
    end
  end

  def no_overlapping_courses
    return unless start_time.present? && end_time.present? && weekday.present? && classroom_id.present?

    overlapping_courses = Course.where(classroom_id: classroom_id, weekday: weekdays[weekday])
                                .where.not(id: id)
                                .where("start_time < ? AND end_time > ?", end_time, start_time)
                                .not_archived

    if overlapping_courses.exists?
      errors.add(:base, "There is already a course scheduled in this classroom at this time")
    end
  end
end
