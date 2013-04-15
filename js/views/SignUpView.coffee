
class SignUpView extends Parse.View
  events:
    "click #signup": "signUp"
    "click #cancel": "cancel"

  initialize: =>
    @render()

  render: =>
    template = $('#signup-template').html()
    @$el.html(template)
    @$el.dialog
      title: "Sign up for Knitplot!"
      close: @cancel
      modal: true
    @$('#email').on "keydown", @onEmailKeyDown
    @$('#password').on "keydown", @onPasswordKeyDown
    @$('#cancel').button()
    @$('#signup').button()
    @$('#facebook').button().on "click", @onFacebookClick

  onEmailKeyDown: (event) =>
    if event.keyCode == 13
      @$('#password').focus()

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
              alert(error.message) if error.message
              knitplot.set "user", Parse.User.current()
      error: (user, error) =>
        alert(error.message) if error.message
        knitplot.set "user", Parse.User.current()

  signUp: =>
    Parse.User.signUp @$('#email').val(), @$('#password').val(),
      email: @$('#email').val()
      name: @$('#email').val()
    ,
      success: =>
        @$el.remove()
        new Knitplot.Views.LoggedInView()
      error: (user, error) =>
        alert(error.message)
        

  cancel: =>
    @$el.remove()


Knitplot.Views ?= {}
Knitplot.Views.SignUpView = SignUpView

