
Knitplot =
 init: ->
   Parse.initialize(
       "732uFxOqiBozGHcv6BUyEZrpQC0oIbmTbi4UJuK2",
       "JB48tpHfZ39NTwrRuQIoqq7GQzpdxLonrjpsj67L")
   new Router()
   Backbone.history.start()

# Export symbols
window.App = Knitplot

