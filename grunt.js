
module.exports = function(grunt) {

  grunt.initConfig({
    coffee: {
      knitplot: {
        files: [
          "coffee/Library.coffee",
          "coffee/Chart.coffee",
          "coffee/ChartParser.coffee",
          "coffee/Graphic.coffee",
          "coffee/Router.coffee",
          "coffee/Knitplot.coffee",
          "coffee/views/NotificationView.coffee",
          "coffee/views/ConfirmationView.coffee",
          "coffee/views/SuccessView.coffee",
          "coffee/views/ErrorView.coffee",
          "coffee/views/LoggedInView.coffee",
          "coffee/views/LoggedOutView.coffee",
          "coffee/views/LogInView.coffee",
          "coffee/views/NeedToSignUpView.coffee",
          "coffee/views/ParseErrorsView.coffee",
          "coffee/views/PatternEditView.coffee",
          "coffee/views/PatternListView.coffee",
          "coffee/views/SignUpView.coffee",
          "coffee/views/SVGPreviewView.coffee"
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

