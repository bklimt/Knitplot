set -x
coffee --join js/knitplot.js --compile \
  coffee/Pattern.coffee \
  coffee/NotificationView.coffee \
  coffee/ErrorView.coffee \
  coffee/PatternEditView.coffee \
  coffee/PatternListView.coffee \
  coffee/Router.coffee \
  coffee/Knitplot.coffee
