App.Views.Home ?= {}
  
class App.Views.Home.Index extends Backbone.View
  template: JST["backbone/templates/find-user"]

  initialize: =>
    @pickupSpotsCollection = new App.Collections.PickupSpots()
    @destinationSpotsCollection = new App.Collections.DestinationSpots()
    @pickupSpotsCollection.on "change, reset", @updateCarpoolerCounts, @
    @destinationSpotsCollection.on 'change, reset', @updateCarpoolerCounts, @
    
  render: =>
    @getUserLocation()
    @$el.html @template()
    @

  getUserLocation: =>
    if navigator.geolocation
      console.log 'geolocation is here!'
      navigator.geolocation.getCurrentPosition(@gotLocation, @couldNotGetLocation)
    else
      console.log 'geolocation is not here!'
      @geolocationNotSupported()

  geolocationNotSupported: =>
    console.log 'geolocation not supported'

  gotLocation: (geoposition) =>
    $.ajax(
      url: "/pickup_spots/nearest_pickup_spots"
      type: 'get'
      dataType: 'json'
      data: geoposition: geoposition
      success: (spotData, response, jqXHR) =>
        console.log spotData
        @nearestSpot = new App.Models.PickupSpot(JSON.parse(spotData.nearest_spot))
        @pickupSpotsCollection.reset JSON.parse(spotData.nearby_spots)

        if @nearestSpot.get('name') == 'San Francisco'
          @userIsInTheCity = true
          @destinationSpotsCollection.reset JSON.parse(spotData.destination_spots)

        viewOptions = 
          waitingCarsCount: @nearestSpot.waitingDrivers.models.length
          waitingRidersCount: @nearestSpot.waitingRiders.models.length
          nearestPickupSpot: @nearestSpot
          distanceRadius: @nearestSpot.distance_radius

        if @userIsInTheCity
          viewOptions['destinations'] = @destinationSpotsCollection
          @renderSFUser viewOptions
        else
          @renderFoundUser viewOptions
          @showSpotStats()
    
      error: () => console.log 'error getting locations!!!!', arguments
    )

  renderFoundUser: (viewOptions) =>
    console.log 'found user!!!!!!!!'
    @$('.request-location').addClass 'hidden'
    @$el.append(JST["backbone/templates/found-user"](options: viewOptions))

  renderSFUser: (viewOptions) =>
    console.log 'user is in san francisco!!', viewOptions
    @$('.request-location').addClass 'hidden'
    @$el.append(JST["backbone/templates/sf-found-user"](options: viewOptions))

  errorGettingNearestPosition: =>
    console.log 'could not get nearest location!'

  couldNotGetLocation: =>
    console.log 'error!!!!!!', arguments

  showSpotStats: =>
    statsTemplate = JST["backbone/templates/pickup-spot-stats"]
    console.log @pickupSpotsCollection
    @$el.append(statsTemplate(pickupSpots: @pickupSpotsCollection.models))

  registerRider: (e) =>
    if @userIsInTheCity
      return @registerSanFranciscoRider e

    return unless @nearestSpot?

    @nearestSpot.waitingRiders.create {pickup_spot_id: @nearestSpot.id},
    wait: true
    success: (newRider, response) =>
      @updateCarpoolerCount(@nearestSpot.id, 'rider', newRider.collection.length)
      @watchCarpooler 'rider', newRider.id
    error: (args) => console.log 'error registering rider', arguments

  registerDriver: (e) =>
    if @userIsInTheCity
      return @registerSanFranciscoDriver e

    return unless @nearestSpot?

    @nearestSpot.waitingDrivers.create {pickup_spot_id: @nearestSpot.id},
    wait: true
    success: (newDriver, response) =>
      @updateCarpoolerCount(@nearestSpot.id, 'driver', newDriver.collection.length)
      @watchCarpooler 'driver', newDriver.id
    error: (args) => console.log 'error registering driver!', arguments

  registerSanFranciscoRider: (e) =>
    destinationSpotId = @getDestinationSpotIdFromEvent e
    @destinationSpotsCollection.find((spot) ->
      console.log 'destination spot id', destinationSpotId
      spot.id == destinationSpotId
    ).waitingRiders.create {destination_spot_id: destinationSpotId},
      wait: true
      success: (newRider, response) =>
        console.log 'the new rider!', newRider
        @updateSanFranciscoCarpoolerCount(destinationSpotId, 'rider', newRider.collection.length)
        @watchCarpooler 'rider', newRider.id

  registerSanFranciscoDriver: (e) =>
    destinationSpotId = @getDestinationSpotIdFromEvent e
    @destinationSpotsCollection.find((spot) ->
      spot.id == destinationSpotId
    ).waitingDrivers.create {destination_spot_id: destinationSpotId},
      wait: true,
      success: (newDriver, response) =>
        console.log 'the new driver!', newDriver
        @updateSanFranciscoCarpoolerCount(destinationSpotId, 'driver', newDriver.collection.length)
        @watchCarpooler 'driver', newDriver.id

  getDestinationSpotIdFromEvent: (e) =>
    $(e.target).closest('.destination-spot-region').data 'destination-spot-id'

  getPickupSpotIdFromEvent: (e) =>
    $(e.target).closest('.pickup-spot-region').data 'pickup-spot-id'

  updateCarpoolerCounts: (carpoolSpotsCollection) =>
    carpoolSpotsCollection.each((spot) =>
      @updateCarpoolerCount(spot.id, 'rider', spot.waitingRiders.length)
      @updateCarpoolerCount(spot.id, 'driver', spot.waitingDrivers.length)
    )

  updateCarpoolerCount: (pickupSpotId, carpoolerType, newCount) =>
    $(".pickup-spot-region[data-pickup-spot-id=#{pickupSpotId}] .#{carpoolerType}-info .#{carpoolerType}-count").text newCount

  updateSanFranciscoCarpoolerCount: (destinationSpotId, carpoolerType, newCount) =>
    $(".destination-spot-region[data-destination-spot-id=#{destinationSpotId}] .#{carpoolerType}-info .#{carpoolerType}-count").text newCount

  updateSanFranciscoCarpoolerCounts: (carpoolSpotsCollection) =>
    console.log carpoolSpotsCollection
    carpoolSpotsCollection.each((spot) =>
      @updateSanFranciscoCarpoolerCount(spot.id, 'rider', spot.waitingRiders.length)
      @updateSanFranciscoCarpoolerCount(spot.id, 'driver', spot.waitingDrivers.length)
    )

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