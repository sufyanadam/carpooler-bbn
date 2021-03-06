#= require_self
#= require_tree ./backbone/templates
#= require_tree ./backbone/routers
#= require_tree ./backbone/views
#= require_tree ./backbone/models
#= require_tree ./backbone/collections

window.App ?= {}
window.App.Views ?= {}
window.App.Routers ?= {}
window.App.Models ?= {}
window.App.Collections ?= {}

Backbone.sync = (method, modelOrCollection, options) ->
  getUrl = (model, method) ->
    if model.methodUrl && _.isFunction model.methodUrl
      model.methodUrl(method || 'read') || (Utils.throwError("A 'url' property or function must be specified"))
    else
      if model.url && _.isFunction model.url
        model.url()
      else
        model.url || (Utils.throwError("A 'url' property or function must be specified"))

  methodMap =
    create: 'POST'
    update: 'PUT'
    delete: 'DELETE'
    read  : 'GET'

  type = methodMap[method]

  params = _.extend({
    contentType: 'application/json'
    type:         type
    dataType:     'json'
    url:          options.url || getUrl modelOrCollection, method
    processData: type == 'GET'
    complete: (jqXHR, textStatus) ->
      modelOrCollection.trigger 'sync:end'
      options.complete(jqXHR, textStatus) if options.complete?
    beforeSend: (xhr) ->
      modelOrCollection.trigger 'sync:start'
  }, options)

  if !params.data && modelOrCollection && (method == 'create' || method == 'update')
    data = {}
    if modelOrCollection.paramRoot
      data[modelOrCollection.paramRoot] = modelOrCollection.toJSON()
    else
      data = modelOrCollection.toJSON()
    params.data = JSON.stringify(data)

  $.ajax params
