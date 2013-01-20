
class ChartGraphicView extends Parse.View
  initialize: =>
    @model = @options.model
    @model.transient.on "change:actions", @onChangeActions
    @model.transient.on "change:selection", @onChangeSelection
    @$el.on "mousedown", @onCanvasMouseDown
    @$el.on "mousemove", @onCanvasMouseMove
    @$el.on "mouseup", @onCanvasMouseUp
    @canvas = new Raphael @el
    @render()


  onChangeActions: =>
    actions = @model.transient.get "actions"
    if chart
      @graphic = new Graphic actions, @canvas.width, @canvas.height
      @graphic.draw @canvas, @model.transient.get "selection"


  onChangeSelection: =>
    @onChangeActions()


  onCanvasMouseDown: (event) =>
    x = event.pageX - @$el.position().left
    y = event.pageY - @$el.position().top
    @mouseDownAction = @graphic.actionAtPoint x, y
    if not @mouseDownAction
      return

    @model.transient.set "selection",
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

    @model.transient.set "selection",
      start:
        row: startAction.textRow
        column: startAction.textColumn
      end:
        row: endAction.textRow
        column: endAction.textColumn + endAction.textLength


  onCanvasMouseUp: (event) =>
    delete @mouseDownAction


  render: =>
    @onChangeActions()
