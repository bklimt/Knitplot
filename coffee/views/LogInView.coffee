
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
    $('#email').on "keydown", @onEmailKeyDown
    $('#password').on "keydown", @onPasswordKeyDown
    $('#dialog-button-bar #cancel').button()
    $('#dialog-button-bar #login').button()
    $('#facebook').button().on "click", @onFacebookClick

  onEmailKeyDown: (event) =>
    if event.keyCode == 13
      $('#password').focus()

  onPasswordKeyDown: (event) =>
    if event.keyCode == 13
      @logIn()

  onFacebookClick: (event) =>
    Parse.FacebookUtils.logIn "",
      success: =>
        FB.api '/me', (me) =>
          Parse.User.current().save
            name: me.name
          ,
            success: =>
              @$el.remove()
              knitplot.set "user", Parse.User.current()
            error: (user, error) =>
              alert(error.message)
              knitplot.set "user", Parse.User.current()
      error: (user, error) =>
        alert(error.message)
        knitplot.set "user", Parse.User.current()

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
