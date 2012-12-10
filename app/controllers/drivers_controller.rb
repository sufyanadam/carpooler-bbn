class DriversController < ApplicationController
  def index
    render :json => Driver.all
  end

  def create
    render :json => Driver.create(params[:driver])
  end

  def update
    driver = Driver.find(params[:id])
    driver.update_attributes :last_seen_lat => driver.current_lat, :last_seen_lng => driver.current_lng, :current_lat => params[:coords][:latitude], :current_lng => params[:coords][:longitude]

    updated_stats = PickupSpot.all.to_json(:include => [:waiting_riders, :waiting_drivers])

    render :json => {:driver => driver.reload, :updated_stats => updated_stats}
  end
end
