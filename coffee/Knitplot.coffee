
class Knitplot
  init: =>
    @start = 0
    @chart = new Chart()

    Parse.initialize(
        "732uFxOqiBozGHcv6BUyEZrpQC0oIbmTbi4UJuK2",
        "JB48tpHfZ39NTwrRuQIoqq7GQzpdxLonrjpsj67L")
    new Router()
    Backbone.history.start()
    $(window).bind('beforeunload', @confirmUnloadMessage)

  newChart: (start) =>
    @chart = new Chart()
    if start
      @start = start

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

  confirmUnload: =>
    message = @confirmUnloadMessage()
    if message
      confirm "Are you sure you want to leave this page?\n\n#{message}"
    else
      true

  confirmUnloadMessage: =>
    if @chart.dirty("text") or @chart.dirty("title")
      "Your chart has not been saved."

# Export symbols
window.knitplot = new Knitplot()

