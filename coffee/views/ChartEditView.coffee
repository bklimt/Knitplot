
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
    chart = knitplot.get "chart"
    if chart
      chart.edit()
      if chart.id
        $("#delete").button().show()
      else
        $("#delete").button().hide()
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
        $("#delete").button().show()
        new SuccessView({ message: "Saved!" })
      error: => new ErrorView({ message: "Unable to save." })
    false


  onDeleteButton: =>
    if not knitplot.get("chart").id
      return
    new ConfirmationView
      message: "Are you sure you want to delete this chart?"
      yes: =>
        knitplot.get("chart").destroy
          success: =>
            knitplot.unset "chart"
            $("#save").button().hide()
            new SuccessView({ message: "Deleted the chart." })
            setTimeout((-> knitplot.defaultChart()), 2000)
          error: => new ErrorView({ message: "Failed to delete chart." })
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
    $("#delete").button().on "click", @onDeleteButton

    if not knitplot.get("chart").id
      $("#delete").button().hide()

    @titleEdit = @$("#title")
    @onChangeTitle()

    library = new LibraryView
      el: @$("#library").get(0)
      chart: knitplot.get "chart"

    graphic = new ChartGraphicView
      el: @$("#chart").get(0)
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

