class Address < ApplicationRecord
  validates :city, presence: true
  validates :street, presence: true
  validates :house, presence: true

  def full_address
    parts = []
    parts << "#{house} #{street}".strip
    parts << city
    parts << npa if npa.present?
    parts.join(", ")
  end
end
