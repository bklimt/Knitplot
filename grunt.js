
module.exports = function(grunt) {

  grunt.initConfig({
    coffee: {
      knitplot: {
        files: [
          "coffee/Router.coffee",
          "coffee/Knitplot.coffee",

          // Models.
          "coffee/models/Chart.coffee",
          "coffee/models/ChartParser.coffee",
          "coffee/models/Graphic.coffee",
          "coffee/models/Library.coffee",
          
          // Notification views.
          "coffee/views/NotificationView.coffee",
          "coffee/views/ConfirmationView.coffee",
          "coffee/views/SuccessView.coffee",
          "coffee/views/ErrorView.coffee",

          // User views.
          "coffee/views/UserView.coffee",
          "coffee/views/LoggedInView.coffee",
          "coffee/views/LoggedOutView.coffee",
          "coffee/views/LogInView.coffee",
          "coffee/views/NeedToSignUpView.coffee",
          "coffee/views/SignUpView.coffee",

          // Chart editing views.
          "coffee/views/ChartLoadingView.coffee",
          "coffee/views/ChartEditView.coffee",
          "coffee/views/ChartGraphicView.coffee",
          "coffee/views/ChartListView.coffee",
          "coffee/views/ParseErrorsView.coffee",
          "coffee/views/ChartTextView.coffee",

          // Other dialogs.
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

