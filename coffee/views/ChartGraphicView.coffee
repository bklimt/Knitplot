
class ChartGraphicView extends Parse.View
  initialize: =>
    @parser = @options.parser
    @parser.on "change:chart", @onChangeChart
    @canvas = new Raphael @el
    @render()

  onChangeChart: =>
    chart = @parser.get "chart"
    if chart
      graphic = new Graphic chart, @canvas.width, @canvas.height
      graphic.draw @canvas

  render: =>
    @onChangeChart()
