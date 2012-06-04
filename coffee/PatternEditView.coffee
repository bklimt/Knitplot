
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

drawShape = (canvas, shape) ->
  if shape.line
    drawLine(canvas, shape)
  if shape.rectangle
    drawRectangle(canvas, shape)

drawGraphic = (canvas, graphic) ->
  for shape in graphic.shapes
    drawShape(canvas, shape)

scaleAndTranslate = (shape, x, y, width, height) ->
  if shape.line
    shape.line =
      point1: [
        shape.line.point1[0] * width + x,
        shape.line.point1[1] * height + y
      ]
      point2: [
        shape.line.point2[0] * width + x,
        shape.line.point2[1] * height + y
      ]
  if shape.rectangle
    shape.rectangle =
      topLeft: [
        shape.rectangle.topLeft[0] * width + x,
        shape.rectangle.topLeft[1] * height + y
      ]
      width: shape.rectangle.width * width
      height: shape.rectangle.height * height

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
          newShape = _.clone(shape)
          newShape.textOffset = action.textOffset
          newShape.textLength = action.textLength
          newShapeX = (columns - (column + action.width)) * columnWidth
          newShapeY = (rows - (rowIndex + 1)) * rowHeight
          newShapeWidth = action.width * columnWidth
          newShapeHeight = rowHeight
          scaleAndTranslate(newShape,
                            newShapeX, newShapeY,
                            newShapeWidth, newShapeHeight)
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

