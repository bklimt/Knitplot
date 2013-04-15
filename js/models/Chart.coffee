
class ChartTransient extends Backbone.Model

class Chart extends Parse.Object
  className: "Chart"

  # Sets up the state for a Chart to be edited.
  edit: ->
    @transient = new ChartTransient
    new Knitplot.Models.ChartParser @
    
Knitplot.Models ?= {}
Knitplot.Models.Chart = Chart

