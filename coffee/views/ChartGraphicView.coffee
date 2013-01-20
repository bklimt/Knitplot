
class ChartGraphicView extends Parse.View
  initialize: =>
    @model = @options.model
    @parser = @options.parser
    @model.on "change:selection", @onChangeSelection
    @parser.on "change:chart", @onChangeChart
    @$el.on "mousedown", @onCanvasMouseDown
    @$el.on "mousemove", @onCanvasMouseMove
    @$el.on "mouseup", @onCanvasMouseUp
    @canvas = new Raphael @el
    @render()


  onChangeSelection: =>
    @onChangeChart()


  onChangeChart: =>
    chart = @parser.get "chart"
    if chart
      @graphic = new Graphic chart, @canvas.width, @canvas.height
      @graphic.draw @canvas, @model.get "selection"


  onCanvasMouseDown: (event) =>
    x = event.pageX - @$el.position().left
    y = event.pageY - @$el.position().top
    @mouseDownAction = @graphic.actionAtPoint x, y
    if not @mouseDownAction
      return

    @model.set "selection",
      start:
        row: @mouseDownAction.textRow
        column: @mouseDownAction.textColumn
      end:
        row: @mouseDownAction.textRow
        column: @mouseDownAction.textColumn + @mouseDownAction.textLength


  onCanvasMouseMove: (event) =>
    if not @mouseDownAction
      return

    x = event.pageX - @$el.position().left
    y = event.pageY - @$el.position().top
    action = @graphic.actionAtPoint x, y

    if not action
      return

    if @mouseDownAction.textOffset < action.textOffset
      startAction = @mouseDownAction
      endAction = action
    else
      startAction = action
      endAction = @mouseDownAction

    @model.set "selection",
      start:
        row: startAction.textRow
        column: startAction.textColumn
      end:
        row: endAction.textRow
        column: endAction.textColumn + endAction.textLength


  onCanvasMouseUp: (event) =>
    delete @mouseDownAction


  render: =>
    @onChangeChart()
