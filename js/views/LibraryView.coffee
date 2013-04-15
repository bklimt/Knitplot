
class LibraryView extends Parse.View
  initialize: ->
    @render
    @chart = @options.chart
    @render()
    @chart.on "change:library", @onChangeLibrary
    knitplot.on "change:libraries", @onChangeLibraries


  onChangeLibrary: =>
    @render()


  onChangeLibraries: =>
    @render()


  onChangeLibrarySelect: =>
    libraryId = @$("#library-select option:selected").attr "value"
    _.each knitplot.get("libraries"), (library) =>
      if library.id == libraryId
        @chart.set "library", library


  render: ->
    template = _.template $("#library-template").html()
    @$el.html template
      libraries: knitplot.get("libraries")
      library: @chart.get("library")
    @$("#library-select").on "change", @onChangeLibrarySelect


Knitplot.Views ?= {}
Knitplot.Views.LibraryView = LibraryView
