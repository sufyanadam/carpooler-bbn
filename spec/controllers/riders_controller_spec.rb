# encoding: UTF-8

require 'spec_helper'

describe RidersController do
  describe "#index" do
    it "returns json containing all riders found" do
      get :index
      response.should be_success
    end
  end
end
