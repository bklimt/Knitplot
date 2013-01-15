
#
# Shape drawing functions
#

drawLine = (canvas, shape) ->
  path =
    "M#{shape.line.point1[0]},#{shape.line.point1[1]}" +
    "L#{shape.line.point2[0]},#{shape.line.point2[1]}"
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
  polygon = canvas.path(path)
  polygon.attr(shape.style)

drawSpline = (canvas, shape) ->
  current = shape.spline[0]
  next = shape.spline[1]
  c = [ (current[0] + next[0]) / 2, (current[1] + next[1]) / 2 ]
  path = "M#{current[0]},#{current[1]}L#{c[0]},#{c[1]}"
  _.each shape.spline[2...], (point) ->
    current = next
    next = point
    c = [ (current[0] + next[0]) / 2, (current[1] + next[1]) / 2 ]
    path = "#{path} Q#{current[0]},#{current[1]} #{c[0]},#{c[1]}"
  path = "#{path} L#{next[0]},#{next[1]}"
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

containsPoint = (shape, x, y) ->
  if shape.rectangle
    left = shape.rectangle.topLeft[0]
    top = shape.rectangle.topLeft[1]
    right = left + shape.rectangle.width
    bottom = top + shape.rectangle.height
    if left <= x < right and top <= y < bottom
      return true
  false

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

class Graphic
  constructor: (chart, maxWidth, maxHeight) ->
    maxWidth = maxWidth - 1
    maxHeight = maxHeight - 1
 
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
    columnWidth = Math.floor(width / columns)
    rowHeight = Math.floor(columnWidth * 0.75)
    height = rowHeight * rows
    if height > maxHeight
      height = maxHeight
      rowHeight = Math.floor(height / rows)
      columnWidth = Math.floor(rowHeight / 0.75)
      width = columnWidth * columns

    # Actually build the graphic
    @graphic = { width: width, height: height, shapes: [] }
    for row, rowIndex in chart
      column = 0
      for action in row
        for rep in [1 .. action.repetitions]
          for shape in action.graphic
            newShapeX = 1 + (columns - (column + action.width)) * columnWidth
            newShapeY = 1 + (rows - (rowIndex + 1)) * rowHeight
            newShapeWidth = action.width * columnWidth
            newShapeHeight = rowHeight
            newShape = scaleAndTranslate(shape,
                                         newShapeX, newShapeY,
                                         newShapeWidth, newShapeHeight)
            newShape.action = action
            @graphic.shapes.push(newShape)
          column = column + action.width

  draw: (canvas) =>
    canvas.clear()
    for shape in @graphic.shapes
      drawShape(canvas, shape)

  _shapeAtPoint: (x, y) =>
    for shape in @graphic.shapes
      if containsPoint(shape, x, y)
        return shape
    undefined

  actionAtPoint: (x, y) =>
    @_shapeAtPoint(x, y)?.action

