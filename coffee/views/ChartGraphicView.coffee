
class ChartGraphicView extends Parse.View
  initialize: =>
    @parser = @options.parser
    @parser.on "change:chart", @onChangeChart
    @$el.on "click", @onCanvasClick
    @canvas = new Raphael @el
    @render()

  onChangeChart: =>
    chart = @parser.get "chart"
    if chart
      @graphic = new Graphic chart, @canvas.width, @canvas.height
      @graphic.draw @canvas

  onCanvasClick: (event) =>
    x = event.pageX - @$el.position().left
    y = event.pageY - @$el.position().top
    action = @graphic.actionAtPoint x, y
    console.log action

  render: =>
    @onChangeChart()
