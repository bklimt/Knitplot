
class Knitplot extends Backbone.Model
  initialize: ->
    Parse.initialize(
        "732uFxOqiBozGHcv6BUyEZrpQC0oIbmTbi4UJuK2",
        "JB48tpHfZ39NTwrRuQIoqq7GQzpdxLonrjpsj67L")

    $(window).bind('beforeunload', @confirmUnloadMessage)

    @set "loading", true
    @on "change:chart", @onChangeChart

    query = new Parse.Query Knitplot.Models.Library
    query.find
      success: (results) =>
        @set
          loading: false
          libraries: results
          defaultLibrary: results[0]

        new Knitplot.Views.AboutView()
        new Knitplot.Views.UserView()
        new Knitplot.Views.ChartListView()
        new Knitplot.Views.ChartEditView
          el: $("#app")

        new Knitplot.Router()
        Backbone.history.start()

      error: (error) ->
        console.log "Unable to load library. Error #{error.code}: #{error.message}"


  onChangeChart: =>
    if @get("chart")?.id
      Backbone.history.navigate("##{@get("chart").id}", { replace: true })
    else
      Backbone.history.navigate("", { replace: true })


  defaultChart: (force) ->
    if (not force) and @get("chart")?.dirty()
      @confirmUnload
        yes: => @defaultChart(true)
      return

    @unset "chart"
    query = new Parse.Query(Knitplot.Models.Chart)
    query.equalTo "creator", Parse.User.current()
    query.descending("updatedAt", "createdAt").skip(@start).limit(1)
    query.include "library"
    query.find
      success: (results) =>
        if results.length > 0
          @set "chart", results[0]
        else
          @newChart(true)
      error: (error) ->
        new Knitplot.Views.ErrorNotificationView
          message: "Unable to load chart. Error #{error.code}: #{error.message}."
    

  newChart: (force) ->
    if (not force) and @get("chart")?.dirty()
      @confirmUnload
        yes: => @newChart(true)
      return

    @set "chart", new Knitplot.Models.Chart
      title: "Untitled"
      text: "k2,p3\nyo4,k2tog"
      library: @get "defaultLibrary"


  editChart: (id, force) ->
    if (not force) and @get("chart")?.dirty()
      @confirmUnload
        yes: => @editChart(id, true)
      return

    @unset "chart"

    if id == "new"
      return @newChart()

    chart = new Knitplot.Models.Chart({ objectId: id })

    chart.fetch
      success: =>
        chart.get("library").fetch
          success: =>
            @set "chart", chart
          error: (library, error) ->
            new Knitplot.Views.ErrorView
              message: "Unable to load library for chart."
            window.location.hash = "#"
      error: (chart, error) ->
        new Knitplot.Views.ErrorView
          message: "Unable to load chart."
        window.location.hash = "#"


  logOut: (force) ->
    if (not force) and @get("chart")?.dirty()
      @confirmUnload
        yes: => @logOut(true)
      return
    Parse.User.logOut()
    knitplot.set "user", Parse.User.current()
    @newChart(true)


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
    if @get("chart")?.dirty()
      "Your chart has not been saved."


window.Knitplot = Knitplot

