
class SignUpView extends Parse.View
  events:
    "click #signup": "signup"
    "click #cancel": "cancel"

  initialize: =>
    @render()

  render: =>
    template = $('#signup-template').html()
    $(@el).html(template)
    $(@el).dialog({ title: "Sign up for Knitplot!", modal: true })
    $('#dialog-button-bar #cancel').button()
    $('#dialog-button-bar #signup').button()

  signup: =>
    Parse.User.signUp $('#email').val(), $('#password').val(),
      email: $('#email').val()
    ,
      success: =>
        $(@el).remove()
        new LoggedInView()
      error: (user, error) =>
        alert(error.message)
        

  cancel: =>
    $(@el).remove()
