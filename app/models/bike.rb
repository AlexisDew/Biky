class Bike < ApplicationRecord
  belongs_to :model
  belongs_to :owner
  belongs_to :city
end
