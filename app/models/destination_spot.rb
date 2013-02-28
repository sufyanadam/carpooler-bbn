class DestinationSpot < ActiveRecord::Base
  attr_accessible :name
  has_many :waiting_riders, class_name: 'Rider'
  has_many :waiting_drivers, class_name: 'Driver'
end
