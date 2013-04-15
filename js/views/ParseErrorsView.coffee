
class ParseErrorsView extends Parse.View
  initialize: =>
    @$el = $("#errors")
    @model = @options.model
    @model.transient.on "change:errors", @onChangeErrors
    @onChangeErrors()

  onChangeErrors: =>
    if @model.transient.get("errors").length == 0
      @$el.hide()
    else
      lines = _.map @model.transient.get("errors"), (error) =>
        "Line #{error.line}, Column #{error.column}: #{error.message}"
      @$el.html lines.join "<br>"
      @$el.show()

Knitplot.Views ?= {}
Knitplot.Views.ParseErrorsView = ParseErrorsView

