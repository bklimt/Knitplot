
class Router extends Backbone.Router
  routes:
    "": "newChart"
    ":id": "editChart"

  newChart: () =>
    knitplot.defaultChart()

  editChart: (id) =>
    knitplot.editChart(id)

