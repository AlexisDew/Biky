class Bike < ApplicationRecord
  belongs_to :model
  belongs_to :owner, class_name: 'User'
  belongs_to :city
end
