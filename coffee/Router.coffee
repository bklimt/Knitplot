
class Router extends Backbone.Router
  routes:
    "": "newChart"
    ":id": "editChart"

  newChart: () =>
    knitplot.newChart()

  editChart: (id) =>
    knitplot.editChart(id)

