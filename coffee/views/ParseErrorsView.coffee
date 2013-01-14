
class ParseErrorsView extends Parse.View
  initialize: =>
    @$el = $("#errors")
    @parser = @options.parser
    @parser.on "change:errors", @onChangeErrors
    @onChangeErrors()

  onChangeErrors: =>
    if @parser.get("errors").length == 0
      @$el.hide()
    else
      lines = _.map @parser.errors, (error) =>
        "Line #{error.line}, Column #{error.column}: #{error.message}"
      @$el.html lines.join "<br>"
      @$el.show()

