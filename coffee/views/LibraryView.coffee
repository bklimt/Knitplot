
class LibraryView extends Parse.View
  initialize: ->
    @render
    @library = @options.chart.get "library"
    @render()


  render: ->
    template = _.template $("#library-template").html()
    @$el.html template
      name: @library.get("name")
      actions: @library.get("data")

