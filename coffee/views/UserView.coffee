
class UserView extends Parse.View
  initialize: ->
    @render()
    knitplot.on "change:user", @onChangeUser


  onChangeUser: =>
    @render()


  render: ->
    if Parse.User.current()
      new LoggedInView()
    else
      new LoggedOutView()

