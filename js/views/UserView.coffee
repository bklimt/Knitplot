
class UserView extends Parse.View
  initialize: ->
    @render()
    knitplot.on "change:user", @onChangeUser


  onChangeUser: =>
    @render()


  render: ->
    if Parse.User.current()
      new Knitplot.Views.LoggedInView()
    else
      new Knitplot.Views.LoggedOutView()


Knitplot.Views ?= {}
Knitplot.Views.UserView = UserView

