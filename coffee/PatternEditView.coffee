
#
# The actual View object
#

class PatternEditView extends Parse.View
  events:
    "submit form": "save"
    "keyup input": "updateTitle"
    "keyup textarea": "updateText"

  initialize: =>
    @parser = new ChartParser()
    @render()

  save: =>
    attrs =
      title: @$('[name=title]').val()
      text: @$('[name=text]').val()
    options =
      error: =>
        new ErrorView({ message: "Unable to set title and text." })
    if knitplot.chart.set(attrs, options)
      knitplot.saveChart()
    false

  updateTitle: =>
    title = @$('[name=title]').val()
    if title != (knitplot.chart.get('title') or "")
      knitplot.chart.set
        title: title
      ,
        error: =>
          new ErrorView({ message: "Unable to set title." })

  updateText: =>
    text = @$('[name=text]').val()
    if text != (knitplot.chart.get('text') or "")
      knitplot.chart.set
        text: text
      ,
        error: =>
          new ErrorView({ message: "Unable to set text." })
    parseResults = @parser.parse(text)
    chart = parseResults.chart
    graphic = new Graphic(chart, @canvas.width, @canvas.height)
    graphic.draw(@canvas)

  render: =>
    template = $("#chart-template").html()
    $(@el).html(_.template(template)({ model: knitplot.chart }))
    $("#app").html(@el)

    $("#save").button()

    @$("[name=title]").val(knitplot.chart.get("title"))
    @$("[name=text]").val(knitplot.chart.get("text"))
    div = @$('[name=chart]')
    @canvas = new Raphael(div.get(0))
    @updateTitle()
    @updateText()
    @delegateEvents()

