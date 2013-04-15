
class SVGPreviewView extends Parse.View
  events:
    "click #okay": "okay"

  initialize: =>
    @url = @options.url
    @render()

  render: =>
    template = $('#svg-preview-template').html()
    $(@el).html(_.template(template)({ url: @url }))
    $(@el).dialog
      title: "SVG"
      modal: true
      width: 640
      height: 480
      position:
        my: "center"
        at: "center"
        of: window
    $("#dialog-button-bar #okay").button()

  okay: =>
    $(@el).remove()
    
Knitplot.Views ?= {}
Knitplot.Views.SVGPreviewView = SVGPreviewView

