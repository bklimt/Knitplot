
class ChartTextView extends Parse.View
  initialize: =>
    @errorMarks = []
    @parser = @options.parser
    @model.on "change:text", @onChangeText
    @parser.on "change:errors", @onChangeErrors
    @render()

  onEditText: =>
    text = @textArea.getValue() or ""
    if text != (@model.get('text') or "")
      @model.set
        text: text
      ,
        error: =>
          new ErrorView({ message: "Unable to set text." })

  onChangeText: =>
    text = @model.get("text") or ""
    if @textArea.getValue() != text
      @textArea.setValue(text)

  onChangeErrors: =>
    # Clear the old error marks.
    _.each @errorMarks, (mark) ->
      mark.clear()
    @errorMarks = []

    # Add and error mark for each of hte new errors.
    _.each @parser.errors, (error) =>
      @errorMarks.push @textArea.markText
        line: error.line - 1
        ch: error.column - 1
      ,
        line: error.line - 1
        ch: (error.column + error.length) - 1
      ,
        className: "error-mark"

  render: =>
    @textArea = CodeMirror.fromTextArea @el,
      theme: "solarized light"
    @textArea.on "change", @onEditText
    @onChangeText()
    @onChangeErrors()

