
#
# Shape drawing functions
#

drawLine = (canvas, shape) ->
  path =
    "M#{shape.line.point1[0]},#{shape.line.point1[1]}" +
    "L#{shape.line.point2[0]},#{shape.line.point2[1]}"
  console.warn(path)
  line = canvas.path(path)
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

drawPolygon = (canvas, shape) ->
  path =
    "M#{shape.polygon[0][0]},#{shape.polygon[0][1]}" +
    ("L#{point[0]},#{point[1]}" for point in shape.polygon[1...]).join("")
  console.warn(path)
  polygon = canvas.path(path)
  polygon.attr(shape.style)

drawSpline = (canvas, shape) ->
  thisX = shape.spline[0][0]
  thisY = shape.spline[0][1]
  nextX = shape.spline[1][0]
  nextY = shape.spline[1][1]
  cX = (thisX + nextX) / 2
  cY = (thisY + nextY) / 2

  path = "M#{thisX},#{thisY}L#{cX},#{cY}"
  _.each shape.spline[2...], (point) ->
    thisX = nextX
    thisY = nextY
    nextX = point[0]
    nextY = point[1]
    cX = (thisX + nextX) / 2
    cY = (thisY + nextY) / 2
    path = "#{path} Q#{thisX},#{thisY} #{cX},#{cY}"
  path = "#{path} L#{nextX},#{nextY}"

  console.warn(path)
  spline = canvas.path(path)
  spline.attr(shape.style)

drawShape = (canvas, shape) ->
  if shape.line
    drawLine(canvas, shape)
  else if shape.rectangle
    drawRectangle(canvas, shape)
  else if shape.circle
    drawCircle(canvas, shape)
  else if shape.polygon
    drawPolygon(canvas, shape)
  else if shape.spline
    drawSpline(canvas, shape)
  else
    console.warn(shape)

drawGraphic = (canvas, graphic) ->
  canvas.clear()
  for shape in graphic.shapes
    drawShape(canvas, shape)

#
# Shape construction functions
#

scaleAndTranslatePoint = (point, x, y, width, height) ->
  [point[0] * width + x, point[1] * height + y]

scaleAndTranslate = (shape, x, y, width, height) ->
  if shape.line
    line:
      point1: scaleAndTranslatePoint(shape.line.point1, x, y, width, height)
      point2: scaleAndTranslatePoint(shape.line.point2, x, y, width, height)
    style: shape.style
  else if shape.rectangle
    rectangle:
      topLeft: scaleAndTranslatePoint(shape.rectangle.topLeft, x, y, width, height)
      width: shape.rectangle.width * width
      height: shape.rectangle.height * height
    style: shape.style
  else if shape.circle
    circle:
      center: scaleAndTranslatePoint(shape.circle.center, x, y, width, height)
      radius: Math.min(shape.circle.radius * width,
                       shape.circle.radius * height)
    style: shape.style
  else if shape.polygon
    polygon: (scaleAndTranslatePoint(point, x, y, width, height) for point in shape.polygon)
    style: shape.style
  else if shape.spline
    spline: (scaleAndTranslatePoint(point, x, y, width, height) for point in shape.spline)
    style: shape.style
  else
    console.warn(shape)
    {}

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

#
# The actual View object
#

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

