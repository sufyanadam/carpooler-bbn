#= require ./super-collection

class App.Collections.PickupSpots extends App.Collections.SuperCollection
  model: App.Models.PickupSpot
  url: "/pickup_spots"
  