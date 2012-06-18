
module.exports = function(grunt) {

  grunt.initConfig({
    coffee: {
      knitplot: {
        files: [
          "coffee/Library.coffee",
          "coffee/Chart.coffee",
          "coffee/ChartParser.coffee",
          "coffee/Graphic.coffee",
          "coffee/NotificationView.coffee",
          "coffee/ErrorView.coffee",
          "coffee/LoggedInView.coffee",
          "coffee/LoggedOutView.coffee",
          "coffee/PatternListView.coffee",
          "coffee/PatternEditView.coffee",
          "coffee/Router.coffee",
          "coffee/Knitplot.coffee"
        ],
        dest: 'js/knitplot.js'
      }
    },

    watch: {
      knitplot: {
        files: "<config:coffee.knitplot.files>",
        tasks: "coffee:knitplot"
      }
    }
  });

  grunt.loadTasks('tasks');
  grunt.registerTask('default', 'coffee');
};

