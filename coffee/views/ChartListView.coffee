
class ChartListView extends Parse.View
  initialize: ->
    @start = @start || 0
    @query = new Parse.Query(Chart)
    @charts = @query.collection()
    @render()
    @fetch()
    knitplot.on "change:chart", @onChangeChart


  onChangeChart: =>
    knitplot.on "change:user", @fetch
    knitplot.get("chart")?.on "save", @fetch
    knitplot.get("chart")?.on "destroy", @fetch


  onClickNew: =>
    knitplot.newChart()


  onClickNext: =>
    @start = @start + 10
    @fetch()


  onClickPrevious: =>
    @start = @start - 10
    if @start < 0
      @start = 0
    @fetch()


  fetch: =>
    $('#spinner').show()
    $("#previous").button("disable")
    $("#next").button("disable")
    @query.equalTo "creator", Parse.User.current()
    @query.descending("updatedAt", "createdAt").skip(@start).limit(11)
    @charts.fetch
      success: =>
        @renderList()
        $('#spinner').hide()
      error: (charts, error) ->
        new ErrorView({ message: "Unable to load chart list." })


  renderList: ->
    @$el.html _.template(@template)
      collection: @charts.first(10)
      start: @start
      previous: @start - 10
      next: if @charts.size() > 10 then @start + 10 else 0
    $("#leftbar").html(@el)
    $("#new").button().on("click", @onClickNew)
    $("#next").button().on("click", @onClickNext)
    $("#previous").button().on("click", @onClickPrevious)


  render: ->
    @template = $("#chart-list-template").html()
    @renderList()

