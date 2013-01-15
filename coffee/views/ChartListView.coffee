
class ChartListView extends Parse.View
  events:
    "click #new": "onClickNew"

  initialize: =>
    @start = @options.start
    @render()

  onClickNew: =>
    knitplot.newChart()

  render: =>
    template = $("#chart-list-template").html()
    $(@el).html _.template(template)
      collection: @collection.first(10)
      start: @start
      previous: @start - 10
      next: if @collection.size() > 10 then @start + 10 else 0
    $("#leftbar").html(@el)
    $("#new").button()
    @delegateEvents()

