App.Views.Home ?= {}
  
class App.Views.Home.Index extends Backbone.View
  template: JST["backbone/templates/home/index"]

  events:
    "click .need-riders" : "findRiders"
    "click .need-drivers" : "findDrivers"

  render: =>
    @$el.html @template()
    @


  findRiders: =>
    @template = JST["backbone/templates/set-pickup-spot"]
    @render()

  findDrivers: =>
    @template = JST["backbone/templates/set-pickup-spot"]
    @render()