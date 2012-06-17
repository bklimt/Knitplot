
module.exports = function(grunt) {

  grunt.initConfig({
    coffee: {
      knitplot: {
        files: [
          "coffee/Library.coffee",
          "coffee/Pattern.coffee",
          "coffee/ChartParser.coffee",
          "coffee/Graphic.coffee",
          "coffee/NotificationView.coffee",
          "coffee/ErrorView.coffee",
          "coffee/PatternEditView.coffee",
          "coffee/PatternListView.coffee",
          "coffee/Router.coffee",
          "coffee/Knitplot.coffee"
        ],
        dest: 'js/knitplot.js'
      }
    }
  });

  grunt.loadTasks('tasks');
  grunt.registerTask('default', 'coffee');
};

