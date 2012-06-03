
class NotificationView extends Parse.View
  className: "success"

  initialize: =>
    @render()

  render: =>
    $(@el).html(@options.message ? "Success!")
    $(@el).hide()
    $("#notification").html(@el)
    $(@el).slideDown()
    $.doTimeout 5000, =>
      $(@el).slideUp()
      $.doTimeout 2000, =>
        $(@el).remove()
    @delegateEvents()

