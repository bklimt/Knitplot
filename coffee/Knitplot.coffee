
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
    @chart = new Chart
      title: "Untitled"
      text: "k2,p3\nyo4,k2tog"
    if start
      @start = start

    @listCharts(@start)
    @showUser()
    new PatternEditView(model: @chart)
    @fixHistory()

  editChart: (id, start) =>
    if id == "new"
      return @newChart(start)

    @chart = new Chart({ objectId: id })
    if start
      @start = start

    @chart.fetch
      success: =>
        new PatternEditView(model: @chart)
      error: (pattern, error) ->
        new ErrorView({ message: "Unable to load chart." })
        window.location.hash = "#"
    @listCharts(@start)
    @showUser()

  saveChart: () =>
    if !knitplot.chart.get "creator"
      knitplot.chart.set "creator", Parse.User.current()
    knitplot.chart.save
      success: =>
        new SuccessView({ message: "Saved!" })
        @listCharts(0)
        @fixHistory()
      error: =>
        new ErrorView({ message: "Unable to save." })

  listCharts: (start = 0) =>
    @start = start
    query = new Parse.Query(Chart)
    query.equalTo "creator", Parse.User.current()
    query.descending("updatedAt", "createdAt").skip(start).limit(11)
    charts = query.collection()
    charts.fetch
      success: =>
        new PatternListView(collection: charts, start: parseInt(start))
      error: (charts, error) ->
        new ErrorView({ message: "Unable to load chart list." })
    @fixHistory()

  showUser: =>
    if Parse.User.current()
      new LoggedInView()
    else
      new LoggedOutView()

  fixHistory: =>
    if @chart.isNew()
      Backbone.history.navigate("#chart/new/#{@start}", { replace: true })
    else
      Backbone.history.navigate("#chart/#{@chart.id}/#{@start}", { replace: true })

  confirmUnload: (options) =>
    message = @confirmUnloadMessage()
    if message
      new ConfirmationView
        message: "Are you sure you want to leave this page?\n\n#{message}"
        yes: options.yes
        no: options.no
    else
      if options.yes
        options.yes()

  confirmUnloadMessage: =>
    if @chart.dirty("text") or @chart.dirty("title")
      "Your chart has not been saved."

# Export symbols
window.knitplot = new Knitplot()

