
class Router extends Backbone.Router
  routes:
    "": "listPatterns"
    "new" : "newPattern"
    "pattern/:id": "editPattern"
    "patterns/:start": "listPatterns"
  
  newPattern: =>
    new PatternEditView(model: new Pattern())

  editPattern: (id) =>
    pattern = new Pattern({ objectId: id })
    pattern.fetch
      success: =>
        new PatternEditView(model: pattern)
      error: (pattern, error) ->
        new Error({ message: "Count not find the pattern." })
        window.location.hash = "#"

  listPatterns: (start = 0) =>
    query = new Parse.Query(Pattern)
    query.descending("updatedAt", "createdAt").skip(start).limit(10)
    patterns = query.collection()
    patterns.fetch
      success: =>
        new PatternListView(collection: patterns, start: parseInt(start))
      error: (patterns, error) ->
        new Error({ message: "Unable to load patterns." })

