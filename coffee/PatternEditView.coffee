
#
# The actual View object
#

class PatternEditView extends Parse.View
  events:
    "submit form": "save"
    "keyup textarea": "update"

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
    graphic = new Graphic(chart, 400, 400)
    graphic.draw(@canvas)

  render: =>
    template = $("#pattern-template").html()
    $(@el).html(_.template(template)({ model: @model }))
    $("#app").html(@el)
    @$("[name=title]").val(@model.get("title"))
    @$("[name=text]").val(@model.get("text"))
    div = @$('[name=chart]')
    @canvas = new Raphael(div.get(0))
    @update()
    @delegateEvents()

