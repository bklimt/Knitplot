
class LogInView extends Parse.View
  events:
    "click #login": "logIn"
    "click #cancel": "cancel"

  initialize: =>
    @render()

  render: =>
    template = $('#login-template').html()
    $(@el).html(template)
    $(@el).dialog({ title: "Log in to Knitplot!", modal: true })
    $('#dialog-button-bar #cancel').button()
    $('#dialog-button-bar #login').button()

  logIn: =>
    Parse.User.logIn $('#email').val(), $('#password').val(),
      success: =>
        @$el.remove()
        knitplot.set "user", Parse.User.current()
      error: (user, error) =>
        alert(error.message)
        knitplot.set "user", Parse.User.current()

  cancel: =>
    $(@el).remove()
