
class LoggedInView extends Parse.View
  initialize: =>
    @render()

  render: =>
    template = _.template($('#logged-in-template').html())
    $(@el).html(template(
      username: Parse.User.current().get('username')
    ))
    $('#user').html(@el)
    @delegateEvents()
