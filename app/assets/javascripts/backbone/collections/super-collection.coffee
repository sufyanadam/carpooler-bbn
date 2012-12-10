class App.Collections.SuperCollection extends Backbone.Collection
  sync: () =>
    console.log arguments
    super