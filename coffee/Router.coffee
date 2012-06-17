
class Router extends Backbone.Router
  routes:
    "": "newChart"
    "new" : "newChart"
    "new/:start" : "newChart"
    "chart/:id": "editChart"
    "chart/:id/:start": "editChart"
    "charts/:start": "listCharts"

  newChart: (start) =>
    if knitplot.confirmUnload()
      knitplot.newChart(start)

  editChart: (id, start) =>
    if knitplot.confirmUnload()
      knitplot.editChart(id, start)

  listCharts: (start = 0) =>
    knitplot.listCharts(start)

