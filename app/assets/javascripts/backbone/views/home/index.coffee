App.Views.Home ?= {}
  
class App.Views.Home.Index extends Backbone.View
  template: JST["backbone/templates/find-user"]

  events:
    "click .car-symbol" : "registerRider"
    "click .man-symbol" : "registerDriver"

  initialize: =>
    @pickupSpotsCollection = new App.Collections.PickupSpots()
    spotModels = []
    _.each(@options.pickupSpots, (spot) ->
      model = new App.Models.PickupSpot(spot)
      spotModels.push model
    )
    @pickupSpotsCollection.reset spotModels
    @pickupSpotsCollection.on "change, reset", @updateCarpoolerCounts, @
    
  render: =>
    @getUserLocation()
    @$el.html @template()
    @

  getUserLocation: =>
    if navigator.geolocation
      navigator.geolocation.getCurrentPosition(@gotLocation, @couldNotGetLocation)
    else
      @geolocationNotSupported()

  geolocationNotSupported: =>
    console.log 'geolocation not supported'

  gotLocation: (geoposition) =>
    $.ajax(
      url: "/pickup_spots/nearest_spot"
      type: 'get'
      dataType: 'json'
      data: geoposition: geoposition
      success: (nearestSpot, response, jqXHR) =>
        spot = new App.Models.PickupSpot(nearestSpot)
        viewOptions = 
          waitingCarsCount: spot.waitingDrivers.models.length
          waitingRidersCount: spot.waitingRiders.models.length
          nearestPickupSpot: spot
          distanceRadius: spot.distance_radius

        @renderFoundUser(viewOptions)
        @showSpotStats()
    
      error: () =>
    )

  renderFoundUser: (viewOptions) =>
    @$('.request-location').addClass 'hidden'
    @$el.append(JST["backbone/templates/found-user"](options: viewOptions))

  errorGettingNearestPosition: =>
    console.log 'could not get nearest location!'

  couldNotGetLocation: =>
    console.log 'error!!!!!!'

  showSpotStats: =>
    statsTemplate = JST["backbone/templates/pickup-spot-stats"]
    @$el.append(statsTemplate(pickupSpots: @pickupSpotsCollection.models))

  registerRider: (e) =>
    pickupSpotId = @getPickupSpotIdFromEvent e
    @pickupSpotsCollection.find((spot) ->
      spot.id == pickupSpotId
    ).waitingRiders.create {pickup_spot_id: pickupSpotId},
    wait: true
    success: (newRider, response) =>
      console.log 'success registering rider, arguments to success callback!', arguments
      @updateCarpoolerCount(pickupSpotId, 'rider', newRider.collection.length)
      @watchCarpooler 'rider', newRider.id
    error: (args) => console.log 'error registering rider', arguments

  registerDriver: (e) =>
    pickupSpotId = @getPickupSpotIdFromEvent e
    @pickupSpotsCollection.find((spot) ->
      spot.id == pickupSpotId
    ).waitingDrivers.create {pickup_spot_id: pickupSpotId},
    wait: true
    success: (newDriver, response) =>
      @updateCarpoolerCount(pickupSpotId, 'driver', newDriver.collection.length)
      @watchCarpooler 'driver', newDriver.id
    error: (args) => console.log 'error registering driver!', arguments

  getPickupSpotIdFromEvent: (e) =>
    $(e.target).closest('.pickup-spot-region').data 'pickup-spot-id'

  updateCarpoolerCounts: (pickupSpotsCollection) =>
    pickupSpotsCollection.each((spot) =>
      @updateCarpoolerCount(spot.id, 'rider', spot.waitingRiders.length)
      @updateCarpoolerCount(spot.id, 'driver', spot.waitingDrivers.length)
    )

  updateCarpoolerCount: (pickupSpotId, carpoolerType, newCount) =>
    $(".pickup-spot-region[data-pickup-spot-id=#{pickupSpotId}] .#{carpoolerType}-info .#{carpoolerType}-count").text newCount

  watchCarpooler: (carpoolerType, id) =>
    updateLastSeenAt = (currentGeoposition) =>
      setInterval =>
        $.ajax
          url: "/#{carpoolerType}s/#{id}"
          type: 'put'
          dataType: 'json'
          data: currentGeoposition
          success: (response, status, jqXHR) =>
            spotModels = []
            _.each(JSON.parse(response.updated_stats), (spot) ->
              
              model = new App.Models.PickupSpot(spot)
              spotModels.push model
            )
            @pickupSpotsCollection.reset spotModels
          error: (status, jqXHR) -> errorUpdatingLastSeenAt(status, jqXHR)
      ,3000

    errorUpdatingLastSeenAt = ->
      console.log 'error updating last seen at!!!', arguments

    currentGeoposition = navigator.geolocation.getCurrentPosition(updateLastSeenAt, errorUpdatingLastSeenAt)