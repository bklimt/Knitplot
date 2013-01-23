
class AboutView extends Parse.View
  initialize: ->
    @render()

  onAboutButton: =>
    new AboutDialogView

  render: ->
    $("#about").button().on "click", @onAboutButton

