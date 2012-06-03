
class PatternListView extends Parse.View
  initialize: =>
    @start = @options.start
    @render()

  render: =>
    template = $("#pattern-list-template").html()
    $(@el).html _.template(template)
      collection: @collection.first(10)
      start: @start
      previous: @start - 10
      next: if @collection.size() > 10 then @start + 10 else 0
    $("#app").html(@el)
    @delegateEvents()

