
#
# The actual View object
#

class PatternEditView extends Parse.View
  events:
    "submit form": "onSaveButton"
    "click #svg": "onSVGButton"
    "keyup input": "onKeyUpTitle"
    "keyup textarea": "onKeyUpText"

  initialize: =>
    @parser = new ChartParser()
    @model.on "change:text", @onChangeText
    @render()

  onSVGButton: =>
    svg = $("#chart").html()
    url = "data:image/svg+xml," + encodeURIComponent(svg)
    new SVGPreviewView
      url: url
    false

  onSaveButton: =>
    if !Parse.User.current()
      new NeedToSignUpView()
      return false
    attrs =
      creator: Parse.User.current()
      title: @$('[name=title]').val()
      text: @$('[name=text]').val()
    options =
      error: =>
        new ErrorView({ message: "Unable to set title and text." })
    if @model.set(attrs, options)
      knitplot.saveChart()
    false

  onKeyUpTitle: =>
    title = @$('[name=title]').val()
    if title != (@model.get('title') or "")
      @model.set
        title: title
      ,
        error: =>
          new ErrorView({ message: "Unable to set title." })

  onChangeTitle: =>
    title = @model.get("title") or ""
    if @titleEdit.val() != title
      @titleEdit.val(title)

  onKeyUpText: =>
    text = @textArea.getValue() or ""
    if text != (@model.get('text') or "")
      @model.set
        text: text
      ,
        error: =>
          new ErrorView({ message: "Unable to set text." })

  onChangeText: =>
    text = @model.get("text") or ""
    # Update the text area.
    if @textArea.getValue() != text
      @textArea.setValue(text)
    # Update the chart.
    parseResults = @parser.parse text
    chart = parseResults.chart
    graphic = new Graphic chart, @canvas.width, @canvas.height
    graphic.draw @canvas

  render: =>
    template = $("#chart-template").html()
    $(@el).html(_.template(template)({ model: @model }))
    $("#app").html @el
    $("#save").button()
    $("#svg").button()

    div = @$('[name=chart]')
    @canvas = new Raphael(div.get(0))
    @textArea = CodeMirror.fromTextArea $("#text")[0],
      theme: "solarized light"
    @onChangeText()

    @titleEdit = @$("[name=title]")
    @onChangeTitle()

    new ParseErrorsView({ parser: @parser })

    @delegateEvents()

