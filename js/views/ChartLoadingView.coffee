
class ChartLoadingView extends Parse.View
  initialize: ->
    @render()


  render: ->
    $("#app").html "Loading"


Knitplot.Views ?= {}
Knitplot.Views.ChartLoadingView = ChartLoadingView

