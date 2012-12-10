class App.Routers.AppRouter extends Backbone.Router
  initialize: (options) =>
    @pickupSpots = options.pickupSpots

  routes:
    ""       : "index"
  index: =>
    view = new App.Views.Home.Index(pickupSpots: @pickupSpots)
    $('.app-region').html view.render().el