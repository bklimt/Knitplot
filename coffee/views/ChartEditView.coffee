
#
# The actual View object
#

class ChartEditView extends Parse.View
  events:
    "keyup input": "onKeyUpTitle"


  initialize: =>
    knitplot.on "change:chart", @onChangeChart
    @render()

 
  onChangeChart: =>
    knitplot.get("chart")?.edit()
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

    $("#save").button({ disabled: true })
    knitplot.get("chart").save
      creator: Parse.User.current()
    ,
      success: (chart) =>
        chart.trigger "save"
        $("#save").button({ label: "Save", disabled: false })
        new SuccessView({ message: "Saved!" })
      error: => new ErrorView({ message: "Unable to save." })
    false


  onKeyUpTitle: =>
    title = @$('#title').val()
    if title != (knitplot.get("chart").get("title") or "")
      knitplot.get("chart").set
        title: title
      ,
        error: =>
          new ErrorView({ message: "Unable to set title." })


  onChangeTitle: =>
    title = knitplot.get("chart").get("title") or ""
    if @titleEdit.val() != title
      @titleEdit.val(title)


  render: =>
    if not knitplot.get("chart")
      new ChartLoadingView()
      return

    template = $("#chart-template").html()
    $(@el).html(_.template(template)({ model: knitplot.get("chart") }))
    $("#app").html @el
    $("#save").button().on "click", @onSaveButton
    $("#svg").button().on "click", @onSVGButton

    @titleEdit = @$("#title")
    @onChangeTitle()

    graphic = new ChartGraphicView
      el: @$('#chart').get(0)
      model: knitplot.get "chart"

    text = new ChartTextView
      el: $("#text").get(0)
      model: knitplot.get "chart"

    # When the graphic is used ot make a selection, focus the text field.
    graphic.$el.on "mouseup", ->
      text.focus()

    new ParseErrorsView
      model: knitplot.get "chart"

    @delegateEvents()

