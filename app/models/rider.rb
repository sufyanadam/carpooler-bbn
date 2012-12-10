class Rider < ActiveRecord::Base
  MAX_LAST_SEEN_AT = 30.seconds

  attr_accessible :pickup_spot_id, :current_lat, :current_lng, :last_seen_at, :last_seen_lat, :last_seen_lng
  belongs_to :pickup_spot
  validates_presence_of :pickup_spot

  def seen!
    update_attribute :last_seen_at, Time.current
  end
end
