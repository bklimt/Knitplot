
class Router extends Backbone.Router
  routes:
    "": "newChart"
    "new" : "newChart"
    "new/:start" : "newChart"
    "chart/:id": "editChart"
    "chart/:id/:start": "editChart"
    "charts/:start": "listCharts"

  newChart: (start) =>
    knitplot.confirmUnload
      yes: ->
        knitplot.newChart(start)
      no: ->
        knitplot.fixHistory()

  editChart: (id, start) =>
    knitplot.confirmUnload
      yes: ->
        knitplot.editChart(id, start)
      no: ->
        knitplot.fixHistory()

  listCharts: (start = 0) =>
    knitplot.listCharts(start)

