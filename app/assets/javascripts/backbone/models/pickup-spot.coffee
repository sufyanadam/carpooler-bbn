class App.Models.PickupSpot extends Backbone.Model
  initialize: (options) =>
    @waitingRiders = new App.Collections.Riders()
    @waitingDrivers = new App.Collections.Drivers()

    riders = []
    _.each(options.waiting_riders, (rider) ->
      riders.push new App.Models.Rider(rider)
    )

    drivers = []
    _.each(options.waiting_drivers, (driver) ->
      drivers.push new App.Models.Driver(driver)
    )

    @waitingRiders.reset riders
    @waitingDrivers.reset drivers

    @waitingRiders.on "change", @handleWaitingRidersChanged
    @waitingDrivers.on "change", @handleWaitingDriversChanged

  defaults:
    id: null
    name: null
    lat: null
    lng: null

  handleWaitingRidersChanged: (e) =>
    console.log 'riders changed!!', e
    @trigger 'change'

  handleWaitingDriversChanged: (e) =>
    console.log 'drivers changed!!', e
    @trigger 'change'