
class PatternListView extends Parse.View
  initialize: =>
    @render()

  render: =>
    template = $("#pattern-list-template").html()
    $(@el).html(_.template(template)({ collection: @collection }))
    $("#app").html(@el)
    @delegateEvents()

