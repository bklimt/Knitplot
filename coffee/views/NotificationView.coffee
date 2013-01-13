
class NotificationView extends Parse.View
  className: "ui-state-highlight ui-corner-all"

  initialize: =>
    @render()

  render: =>
    $(@el).html(@options.message ? "Success!")
    notification = $("#notification")
    notification.html(@el)
    notification.hide()
    notification.slideDown()
    $.doTimeout 3000, =>
      notification.slideUp()
      $.doTimeout 20000, =>
        notification.remove()
    @delegateEvents()

