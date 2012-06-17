
class Knitplot
  init: =>
    @start = 0
    @model = new Chart()

    Parse.initialize(
        "732uFxOqiBozGHcv6BUyEZrpQC0oIbmTbi4UJuK2",
        "JB48tpHfZ39NTwrRuQIoqq7GQzpdxLonrjpsj67L")
    new Router()
    Backbone.history.start()

  newChart: =>
    @chart = new Chart()
    @listCharts(@start)
    new PatternEditView()
    @fixHistory()

  editChart: (id, start) =>
    @chart = new Chart({ objectId: id })
    if start
      @start = start

    @chart.fetch
      success: =>
        new PatternEditView()
      error: (pattern, error) ->
        new Error({ message: "Unable to load chart." })
        window.location.hash = "#"
    @listCharts(@start)

  saveChart: () =>
    knitplot.chart.save
      success: =>
        new NotificationView({ message: "Saved!" })
        @listCharts(0)
        @fixHistory()
      error: =>
        new ErrorView({ message: "Unable to save." })

  listCharts: (start = 0) =>
    @start = start
    query = new Parse.Query(Chart)
    query.descending("updatedAt", "createdAt").skip(start).limit(11)
    charts = query.collection()
    charts.fetch
      success: =>
        new PatternListView(collection: charts, start: parseInt(start))
      error: (charts, error) ->
        new Error({ message: "Unable to load chart list." })
    @fixHistory()

  fixHistory: =>
    if @chart.isNew()
      Backbone.history.navigate("#chart/new/#{@start}", { replace: true })
    else
      Backbone.history.navigate("#chart/#{@chart.id}/#{@start}", { replace: true })

# Export symbols
window.knitplot = new Knitplot()

