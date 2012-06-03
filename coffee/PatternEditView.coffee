
class PatternEditView extends Parse.View
  events:
    "submit form": "save"
    "keypress textarea": "update"

  initialize: =>
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
    library =
      p: { width: 1 }
      k3tog: { width: 3 }
    parser = new ChartParser()
    chart = parser.parse(text, library)
    console.warn(chart)

  render: =>
    template = $("#pattern-template").html()
    $(@el).html(_.template(template)({ model: @model }))
    $("#app").html(@el)
    @$("[name=title]").val(@model.get("title"))
    @$("[name=text]").val(@model.get("text"))
    @delegateEvents()

