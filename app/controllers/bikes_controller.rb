class BikesController < ApplicationController
  # skip_before_action :authenticate_user!, only: %i[index show] # [:index, :show]
  # authenticate use before showing bikes not in the first version
  before_action :find_bike, only: [:show]
  # skip_before_action :authenticate_user!, only: [:index]

  def index
    if params[:city].present?
      city_id = City.where(name: params[:city].capitalize)
      bikes = Bike.where(city: city_id)
      check_availability(bikes)
    else
      bikes = Bike.all
      check_availability(bikes)
    end
  end

  def show
    @booking = Booking.new
  end

  def new
    @bike = Bike.new
  end

  def create
    @bike = Bike.new(bike_params)
    # if @bike.save!
    #   redirect_to bike_path(@bike)
    # else
    #   render :new
    # end
  end

  def edit
  end

  def update
  end

  def destroy
  end

  private

  def check_availability(bikes)
    @bikes = []
    bikes.each do |bike|
      @bikes << bike if bike.available?(start_date: params[:start_date], end_date: params[:end_date])
    end
  end

  def find_bike
    @bike = Bike.find(params[:id])
  end

  def bike_params
    # params.require(:bike).permit(:name, :description)
  end
end
