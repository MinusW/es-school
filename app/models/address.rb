class Address < ApplicationRecord
  has_many :users

  validates :city, presence: true
  validates :street, presence: true
  validates :house, presence: true
end
