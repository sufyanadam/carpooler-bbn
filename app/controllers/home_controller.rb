class HomeController < ApplicationController
  def show
    @pickup_spots = PickupSpot.all.to_json :include => [:waiting_riders, :waiting_drivers]
  end
end
