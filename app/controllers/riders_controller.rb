class RidersController < ApplicationController
  def index
    render :json => Rider.all
  end

  def create
    render :json => Rider.create(params[:rider])
  end

  def update
    rider = Rider.find(params[:id])
    rider.update_attributes :last_seen_lat => rider.current_lat, :last_seen_lng => rider.current_lng, :current_lat => params[:coords][:latitude], :current_lng => params[:coords][:longitude]

    updated_stats = PickupSpot.all.to_json(:include => [:waiting_riders, :waiting_drivers])

    render :json => {:rider => rider.reload, :updated_stats => updated_stats}
  end
end
