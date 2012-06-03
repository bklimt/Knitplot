
class Pattern extends Parse.Object
  className: "Pattern"

class NotificationView extends Parse.View
  className: "success"

  initialize: =>
    @render()

  render: =>
    $(@el).html(@options.message ? "Success!")
    $(@el).hide()
    $("#notification").html(@el)
    $(@el).slideDown()
    $.doTimeout 5000, =>
      $(@el).slideUp()
      $.doTimeout 2000, =>
        $(@el).remove()
    @delegateEvents()

class ErrorView extends NotificationView
  className: "error"

class PatternEditView extends Parse.View
  events:
    "submit form": "save"

  initialize: =>
    @model.bind("change", @render)
    @render()

  save: =>
    @model.set(
      title: @$('[name=title]').val()
      text: @$('[name=text]').val()
    )
    @model.save(
      success: ->
        new NotificationView({ message: "Saved!" })
        Backbone.history.saveLocation("documents/#{@model.id}")
      error: ->
        new ErrorView({ message: "Unable to save." })
    )
    false

  render: =>
    template = $("#pattern-template").html()
    $(@el).html(_.template(template)({ model: @model }))
    $("#app").html(@el)
    @$("[name=title]").val(@model.get("title"))
    @$("[name=text]").val(@model.get("text"))
    @delegateEvents()

class PatternListView extends Parse.View
  initialize: =>
    @render()

  render: =>
    template = $("#pattern-list-template").html()
    $(@el).html(_.template(template)({ collection: @collection }))
    $("#app").html(@el)
    @delegateEvents()

class Router extends Backbone.Router
  routes:
    "": "listPatterns"
    "new" : "newPattern"
    "patterns/:id": "editPattern"
  
  newPattern: =>
    new PatternEditView(model: new Pattern())

  editPattern: (id) =>
    pattern = new Pattern({ objectId: id })
    pattern.fetch
      success: =>
        new PatternEditView(model: pattern)
      error: (pattern, error) ->
        new Error({ message: "Count not find the pattern." })
        window.location.hash = "#"

  listPatterns: =>
    query = new Parse.Query(Pattern)
    query.descending("createdAt")
    query.limit(10)
    patterns = query.collection()
    patterns.fetch
      success: =>
        new PatternListView({ collection: patterns })
      error: (patterns, error) ->
        new Error({ message: "Unable to load patterns." })

App =
 init: ->
   Parse.initialize(
       "732uFxOqiBozGHcv6BUyEZrpQC0oIbmTbi4UJuK2",
       "JB48tpHfZ39NTwrRuQIoqq7GQzpdxLonrjpsj67L")
   new Router()
   Backbone.history.start()

# Export symbols
window.App = App

