class Bike < ApplicationRecord
  belongs_to :model
  belongs_to :owner, class_name: 'User'
  belongs_to :city

  has_many :users, through: :bookings
  has_many :bookings
end
