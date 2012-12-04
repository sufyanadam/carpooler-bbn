class App.Routers.AppRouter extends Backbone.Router
  routes:
    "" : "index"
    "riders"

  index: =>
    view = new App.Views.Home.Index()
    $('.app-region').html view.render().el