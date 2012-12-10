class PickupSpot < ActiveRecord::Base
  attr_accessible :name, :lat, :lng
  has_many :waiting_riders, :class_name => 'Rider'
  has_many :waiting_drivers, :class_name => 'Driver'

  reverse_geocoded_by :lat, :lng

  def self.nearest_to geoposition
    near([geoposition[:coords][:latitude], geoposition[:coords][:longitude]], 10).first
  end
end
