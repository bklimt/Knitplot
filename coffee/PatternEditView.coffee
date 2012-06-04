
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
    chart = @parser.parse(text)
    circle = @canvas.circle(0, 0, 40)
    circle.attr("fill", "#ff0000")

  render: =>
    template = $("#pattern-template").html()
    $(@el).html(_.template(template)({ model: @model }))
    $("#app").html(@el)
    @$("[name=title]").val(@model.get("title"))
    @$("[name=text]").val(@model.get("text"))
    div = @$('[name=chart]')
    @canvas = new Raphael(div.get(0))
    @delegateEvents()

