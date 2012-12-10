# encoding UTF-8

require 'spec_helper'

describe DriversController do
  describe "#index" do
    it "returns json containing all drivers" do
      get :index
      response.should be_success
    end
  end

  describe "#new" do
    it "creates a new driver" do
      -> { post :create, :driver => {:pickup_spot_id => PickupSpot.create!.id }}.should change { Driver.count }.by +1
      response.should be_success
    end
  end
end
