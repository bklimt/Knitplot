
#
# The actual View object
#

class ChartEditView extends Parse.View
  events:
    "submit form": "onSaveButton"
    "click #svg": "onSVGButton"
    "keyup input": "onKeyUpTitle"

  initialize: =>
    @model = @options.model
    @model.edit()
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
      title: @$('#title').val()
      text: @$('#text').val()
    options =
      error: =>
        new ErrorView({ message: "Unable to set title and text." })
    if @model.set(attrs, options)
      knitplot.saveChart()
    false

  onKeyUpTitle: =>
    title = @$('#title').val()
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

  render: =>
    template = $("#chart-template").html()
    $(@el).html(_.template(template)({ model: @model }))
    $("#app").html @el
    $("#save").button()
    $("#svg").button()

    @titleEdit = @$("#title")
    @onChangeTitle()

    graphic = new ChartGraphicView
      el: @$('#chart').get(0)
      model: @model

    text = new ChartTextView
      el: $("#text").get(0)
      model: @model

    # When the graphic is used ot make a selection, focus the text field.
    graphic.$el.on "mouseup", ->
      text.focus()

    new ParseErrorsView
      model: @model

    @delegateEvents()

