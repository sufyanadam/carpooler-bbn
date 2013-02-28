class App.Routers.AppRouter extends Backbone.Router
  initialize: (options) =>

  routes:
    ""       : "index"
  index: =>
    view = new App.Views.Home.Index()
    $('.app-region').html view.render().el