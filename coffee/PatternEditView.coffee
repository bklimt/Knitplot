
drawLine = (canvas, shape) ->
  line = canvas.path(
    "M#{shape.line.point1[0]},#{shape.line.point1[1]}" +
    "L#{shape.line.point2[0]},#{shape.line.point2[1]}")
  line.attr(shape.style)

drawRectangle = (canvas, shape) ->
  rect = canvas.rect(shape.rectangle.topLeft[0],
                     shape.rectangle.topLeft[1],
                     shape.rectangle.width,
                     shape.rectangle.height)
  rect.attr(shape.style)

drawCircle = (canvas, shape) ->
  circle = canvas.circle(shape.circle.center[0],
                         shape.circle.center[1],
                         shape.circle.radius)
  circle.attr(shape.style)

drawShape = (canvas, shape) ->
  if shape.line
    drawLine(canvas, shape)
  else if shape.rectangle
    drawRectangle(canvas, shape)
  else if shape.circle
    drawCircle(canvas, shape)
  else
    console.warn(shape)

drawGraphic = (canvas, graphic) ->
  canvas.clear()
  for shape in graphic.shapes
    drawShape(canvas, shape)

scaleAndTranslate = (shape, x, y, width, height) ->
  if shape.line
    line:
      point1: [
        shape.line.point1[0] * width + x,
        shape.line.point1[1] * height + y
      ]
      point2: [
        shape.line.point2[0] * width + x,
        shape.line.point2[1] * height + y
      ]
    style: shape.style
  else if shape.rectangle
    rectangle:
      topLeft: [
        shape.rectangle.topLeft[0] * width + x,
        shape.rectangle.topLeft[1] * height + y
      ]
      width: shape.rectangle.width * width
      height: shape.rectangle.height * height
    style: shape.style
  else if shape.circle
    circle:
      center: [
        shape.circle.center[0] * width + x,
        shape.circle.center[1] * height + y
      ]
      radius: Math.min(shape.circle.radius * width,
                       shape.circle.radius * height)
    style: shape.style
  else
    console.warn(shape)

makeGraphic = (chart, maxWidth, maxHeight) ->
  # Figure out how many columns there are.
  columns = 1
  for row in chart
    column = 0
    for action in row
      column = column + (action.width * action.repetitions)
    if column > columns
      columns = column
  rows = chart.length

  # Find the actual dimensions, given the aspect ratio.
  width = maxWidth
  columnWidth = width / columns
  rowHeight = columnWidth * 0.75
  height = rowHeight * rows
  if height > maxHeight
    height = maxHeight
    rowHeight = height / rows
    columnWidth = rowHeight / 0.75
    width = columnWidth * columns

  # Actually build the graphic
  graphic = { width: width, height: height, shapes: [] }
  for row, rowIndex in chart
    column = 0
    for action in row
      for rep in [1 .. action.repetitions]
        for shape in action.graphic
          newShapeX = (columns - (column + action.width)) * columnWidth
          newShapeY = (rows - (rowIndex + 1)) * rowHeight
          newShapeWidth = action.width * columnWidth
          newShapeHeight = rowHeight
          newShape = scaleAndTranslate(shape,
                                       newShapeX, newShapeY,
                                       newShapeWidth, newShapeHeight)
          newShape.textOffset = action.textOffset
          newShape.textLength = action.textLength
          graphic.shapes.push(newShape)
        column = column + action.width

  return graphic

class PatternEditView extends Parse.View
  events:
    "submit form": "save"
    "keypress textarea": "update"

  initialize: =>
    @parser = new ChartParser()
    @model.bind("change", @render)
    @render()

  save: =>
    @model.save
      title: @$('[name=title]').val()
      text: @$('[name=text]').val()
    ,
      success: =>
        new NotificationView({ message: "Saved!" })
        Backbone.history.navigate("pattern/#{@model.id}")
      error: =>
        new ErrorView({ message: "Unable to save." })
    false

  update: =>
    text = @$('[name=text]').val()
    parseResults = @parser.parse(text)
    chart = parseResults.chart
    graphic = makeGraphic(chart, 400, 400)
    drawGraphic(@canvas, graphic)

  render: =>
    template = $("#pattern-template").html()
    $(@el).html(_.template(template)({ model: @model }))
    $("#app").html(@el)
    @$("[name=title]").val(@model.get("title"))
    @$("[name=text]").val(@model.get("text"))
    div = @$('[name=chart]')
    @canvas = new Raphael(div.get(0))
    @delegateEvents()

