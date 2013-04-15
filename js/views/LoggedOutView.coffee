
class LoggedOutView extends Parse.View
  events:
    "click #login": "logIn"
    "click #signup": "signUp"

  initialize: =>
    @render()

  render: =>
    template = $('#logged-out-template').html()
    $(@el).html(_.template(template)({}))
    $('#user').html(@el)

    $('#signup').button()
    $('#login').button()

    @delegateEvents()

  logIn: =>
    new Knitplot.Views.LogInView()

  signUp: =>
    new Knitplot.Views.SignUpView()

Knitplot.Views ?= {}
Knitplot.Views.LoggedOutView = LoggedOutView
