class PickupSpotsController < ApplicationController
  def index
   render :json => PickupSpot.all.to_json(:include => [:waiting_riders, :waiting_drivers])
  end

  def nearest_spot
    render :json => PickupSpot.nearest_to(params[:geoposition]).to_json(:include => [:waiting_riders, :waiting_drivers])
  end
end
