set -x
coffee --join js/knitplot.js --compile \
  coffee/ChartParser.coffee \
  coffee/Pattern.coffee \
  coffee/NotificationView.coffee \
  coffee/ErrorView.coffee \
  coffee/PatternEditView.coffee \
  coffee/PatternListView.coffee \
  coffee/Router.coffee \
  coffee/Knitplot.coffee
