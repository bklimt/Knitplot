
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
    new Knitplot.Views.SVGPreviewView
      url: url
    no


  onSaveButton: =>
    if !Parse.User.current()
      new Knitplot.Views.NeedToSignUpView()
      return false

    $("#save").button({ disabled: true })
    knitplot.get("chart").save
      creator: Parse.User.current()
    ,
      success: (chart) =>
        chart.trigger "save"
        $("#save").button({ label: "Save", disabled: false })
        $("#delete").button().show()
        new Knitplot.Views.SuccessView({ message: "Saved!" })
      error: => new Knitplot.Views.ErrorView({ message: "Unable to save." })
    no


  onDeleteButton: =>
    if not knitplot.get("chart").id
      return
    new Knitplot.Views.ConfirmationView
      message: "Are you sure you want to delete this chart?"
      yes: =>
        knitplot.get("chart").destroy
          success: =>
            knitplot.unset "chart"
            $("#save").button().hide()
            new Knitplot.Views.SuccessView
              message: "Deleted the chart."
            setTimeout((-> knitplot.defaultChart()), 2000)
          error: =>
            new Knitplot.Views.ErrorView
              message: "Failed to delete chart."
    no


  onKeyUpTitle: =>
    title = @$('#title').val()
    if title != (knitplot.get("chart").get("title") or "")
      knitplot.get("chart").set
        title: title
      ,
        error: =>
          new Knitplot.Views.ErrorView({ message: "Unable to set title." })


  onChangeTitle: =>
    title = knitplot.get("chart").get("title") or ""
    if @titleEdit.val() != title
      @titleEdit.val(title)


  render: =>
    if not knitplot.get("chart")
      new Knitplot.Views.ChartLoadingView()
      return

    template = $("#chart-template").html()
    @$el.html(_.template(template)({ model: knitplot.get("chart") }))
    $("#save").button().on "click", @onSaveButton
    $("#svg").button().on "click", @onSVGButton
    $("#delete").button().on "click", @onDeleteButton

    if not knitplot.get("chart").id
      $("#delete").button().hide()

    @titleEdit = @$("#title")
    @onChangeTitle()

    library = new Knitplot.Views.LibraryView
      el: @$("#library").get(0)
      chart: knitplot.get "chart"

    graphic = new Knitplot.Views.ChartGraphicView
      el: @$("#chart").get(0)
      model: knitplot.get "chart"

    text = new Knitplot.Views.ChartTextView
      el: $("#text").get(0)
      model: knitplot.get "chart"

    # When the graphic is used ot make a selection, focus the text field.
    graphic.$el.on "mouseup", ->
      text.focus()

    new Knitplot.Views.ParseErrorsView
      model: knitplot.get "chart"

    @delegateEvents()

Knitplot.Views ?= {}
Knitplot.Views.ChartEditView = ChartEditView

