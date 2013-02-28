class PickupSpotsController < ApplicationController
  def index
    render json: PickupSpot.all.to_json(include: [:waiting_riders, :waiting_drivers])
  end

  def nearest_pickup_spots
    nearest_spots = PickupSpot.near([params[:geoposition][:coords][:latitude], params[:geoposition][:coords][:longitude]], 9, order: :distance)

    if nearest_spots[0].name == "San Francisco"
      destination_spots = DestinationSpot.where("name != 'San Francisco'").to_json(include: [:waiting_riders, :waiting_drivers])
      render json: { nearest_spot: nearest_spots.delete_at(0).to_json(include:[:waiting_riders, :waiting_drivers]), destination_spots: destination_spots } and return
    end

    render json: { nearest_spot: nearest_spots.delete_at(0).to_json(include:[:waiting_riders, :waiting_drivers]), nearby_spots: nearest_spots.to_json(include: [:waiting_riders, :waiting_drivers]) }
  end
end
