
class LoggedInView extends Parse.View
  events:
    "click #username": "logOut"

  initialize: =>
    @render()

  render: =>
    template = _.template($('#logged-in-template').html())
    $(@el).html(template(
      username: Parse.User.current().get('username')
    ))
    $('#user').html(@el)
    $('#username').button()

    @delegateEvents()

  logOut: =>
    Parse.User.logOut()
    new ConfirmationView
      message: "Are you sure you want to log out?"
      yes: ->
        new LoggedOutView()
