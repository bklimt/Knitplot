
class ConfirmationView extends Parse.View
  events:
    "click #yes": "yes"
    "click #no": "no"

  initialize: =>
    @render()

  render: =>
    template = _.template($('#confirmation-template').html())
    $(@el).html(template(
      message: @options.message or "Are you sure?"
    ))
    $(@el).dialog
      title: @options.title or "Are you sure?"
      modal: true
    $('#dialog-button-bar #no').button()
    $('#dialog-button-bar #yes').button()

  yes: =>
    if @options.yes
      @options.yes()
    $(@el).remove()

  no: =>
    if @options.no
      @options.no()
    $(@el).remove()


Knitplot.Views ?= {}
Knitplot.Views.ConfirmationView = ConfirmationView

