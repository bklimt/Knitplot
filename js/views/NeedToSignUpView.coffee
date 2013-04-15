
class NeedToSignUpView extends Parse.View
  events:
    "click #okay": "okay"

  initialize: =>
    @render()

  render: =>
    template = $('#need-to-sign-up-template').html()
    $(@el).html(template)
    $(@el).dialog({ title: "Sign up for Knitplot!", modal: true })
    $('#dialog-button-bar #okay').button()

  okay: =>
    $(@el).remove()

Knitplot.Views ?= {}
Knitplot.Views.NeedToSignUpView = NeedToSignUpView

