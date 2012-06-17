
#
# The actual View object
#

class PatternEditView extends Parse.View
  events:
    "submit form": "save"
    "keyup textarea": "update"

  initialize: =>
    @parser = new ChartParser()
    @render()

  save: =>
    knitplot.chart.set
      title: @$('[name=title]').val()
      text: @$('[name=text]').val()
    ,
      success: =>
        knitplot.saveChart()
      error: =>
        new ErrorView({ message: "Unable to set title and text." })
    false

  update: =>
    text = @$('[name=text]').val()
    parseResults = @parser.parse(text)
    chart = parseResults.chart
    graphic = new Graphic(chart, @canvas.width, @canvas.height)
    graphic.draw(@canvas)

  render: =>
    template = $("#chart-template").html()
    $(@el).html(_.template(template)({ model: knitplot.chart }))
    $("#app").html(@el)
    @$("[name=title]").val(knitplot.chart.get("title"))
    @$("[name=text]").val(knitplot.chart.get("text"))
    div = @$('[name=chart]')
    @canvas = new Raphael(div.get(0))
    @update()
    @delegateEvents()

