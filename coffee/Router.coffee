
class Router extends Backbone.Router
  routes:
    "": "newChart"
    "new" : "newChart"
    "chart/:id": "editChart"
    "chart/:id/:start": "editChart"
    "charts/:start": "listCharts"

  newChart: =>
    knitplot.newChart()

  editChart: (id, start) =>
    knitplot.editChart(id, start)

  listCharts: (start = 0) =>
    knitplot.listCharts(start)

