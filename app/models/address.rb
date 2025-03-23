class Address < ApplicationRecord
  belongs_to :user, optional: true

  validates :city, presence: true
  validates :street, presence: true
  validates :house, presence: true
end
