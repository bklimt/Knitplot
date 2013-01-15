
#
# The actual View object
#

class ChartEditView extends Parse.View
  events:
    "submit form": "onSaveButton"
    "click #svg": "onSVGButton"
    "keyup input": "onKeyUpTitle"

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

  onChangeText: =>
    @parser.parse @model.get "text"

  render: =>
    template = $("#chart-template").html()
    $(@el).html(_.template(template)({ model: @model }))
    $("#app").html @el
    $("#save").button()
    $("#svg").button()

    @titleEdit = @$("[name=title]")
    @onChangeTitle()

    new ChartGraphicView
      el: @$('[name=chart]').get(0)
      parser: @parser

    new ChartTextView
      el: $("#text").get(0)
      model: @model
      parser: @parser

    @onChangeText()

    new ParseErrorsView
      parser: @parser

    @delegateEvents()

