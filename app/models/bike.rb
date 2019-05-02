class Bike < ApplicationRecord
  belongs_to :model
  belongs_to :owner, class_name: 'User'
  belongs_to :city

  has_many :users, through: :bookings
  has_many :bookings

  def unavailable_dates
    bookings.pluck(:start_date, :end_date).map do |range|
      { from: range[0], to: range[1] }
    end
  end

  def available?(attributes = {})
    # No attributes given, or only one (by default checks todays availability)
    attributes[:start_date] = Date.today if attributes[:start_date].nil?
    attributes[:end_date]   = attributes[:start_date] if attributes[:end_date].nil?

    # Convert to dates if strings given
    attributes[:start_date] = attributes[:start_date].to_date
    attributes[:end_date]   = attributes[:end_date].to_date

    # Check if attributes are includes in unavailable_dates
    unavailable_dates.each do |range|
      return false if attributes[:start_date] >= range[:from] && attributes[:start_date] <= range[:to]
      return false if attributes[:end_date] >= range[:from] && attributes[:start_date] <= range[:to]
    end
    return true
  end
end
