
class ChartTransient extends Backbone.Model

class Chart extends Parse.Object
  className: "Chart"

  # Sets up the state for a Chart to be edited.
  edit: ->
    @transient = new ChartTransient
    new ChartParser @
    

