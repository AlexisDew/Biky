class BikeEquipment < ApplicationRecord
  belongs_to :bike
  belongs_to :equipment
end
