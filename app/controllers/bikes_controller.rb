class BikesController < ApplicationController
  # skip_before_action :authenticate_user!, only: %i[index show] # [:index, :show]
  # authenticate use before showing bikes not in the first version
  before_action :find_bike, only: [:show]

  def index
    @bikes = Bike.all
  end

  def show
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

  def find_bike
    @bike = Bike.find(params[:id])
  end

  def bike_params
    # params.require(:bike).permit(:name, :description)
  end
end
