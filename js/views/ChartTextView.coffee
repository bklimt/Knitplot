
class ChartTextView extends Parse.View
  initialize: =>
    @errorMarks = []
    @model.on "change:text", @onChangeText
    @model.transient.on "change:selection", @onChangeSelection
    @model.transient.on "change:errors", @onChangeErrors
    @render()


  focus: =>
    @textArea.focus()


  onEditText: =>
    text = @textArea.getValue() or ""
    if text != (@model.get('text') or "")
      @model.set
        text: text
      ,
        error: =>
          new ErrorView({ message: "Unable to set text." })


  onCursorActivity: =>
    start = @textArea.getCursor "start"
    end = @textArea.getCursor "end"
    @model.transient.set "selection",
      start:
        row: start.line
        column: start.ch
      end:
        row: end.line
        column: end.ch


  onChangeText: =>
    text = @model.get("text") or ""
    if @textArea.getValue() != text
      @textArea.setValue(text)


  onChangeSelection: =>
    selection = @model.transient.get "selection"
    if not selection
      return
    start = @textArea.getCursor "start"
    end = @textArea.getCursor "end"
    if (start.line != selection.start.row or
        start.ch != selection.start.column or
        end.line != selection.end.row or
        end.ch != selection.end.column)
      @textArea.setSelection
        line: selection.start.row
        ch: selection.start.column
      ,
        line: selection.end.row
        ch: selection.end.column


  onChangeErrors: =>
    # Clear the old error marks.
    _.each @errorMarks, (mark) ->
      mark.clear()
    @errorMarks = []

    # Add and error mark for each of hte new errors.
    _.each @model.transient.get("errors"), (error) =>
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
    @textArea.on "cursorActivity", @onCursorActivity
    @onChangeText()
    @onChangeErrors()


Knitplot.Views ?= {}
Knitplot.Views.ChartTextView = ChartTextView
