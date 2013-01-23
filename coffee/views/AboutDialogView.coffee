
class AboutDialogView extends Parse.View
  events:
    "click #okay": "okay"

  initialize: =>
    @render()

  render: =>
    template = $('#about-template').html()
    $(@el).html(template)
    $(@el).dialog({ title: "About KnitPlot!", modal: true })
    $('#dialog-button-bar #okay').button()

  okay: =>
    $(@el).remove()

