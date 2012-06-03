
class PatternListView extends Parse.View
  initialize: =>
    @start = @options.start
    @render()

  render: =>
    template = $("#pattern-list-template").html()
    $(@el).html _.template(template)
      collection: @collection
      start: @start
      previous: @start - 10
      next: @start + 10
    $("#app").html(@el)
    @delegateEvents()

