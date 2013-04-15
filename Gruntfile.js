
module.exports = function(grunt) {
  grunt.initConfig({
    coffee: {
      knitplot: {
        files: {
          "build/knitplot.js": [
            "js/Knitplot.coffee",
            "js/Router.coffee",

            // Models.
            "js/models/Chart.coffee",
            "js/models/ChartParser.coffee",
            "js/models/Graphic.coffee",
            "js/models/Library.coffee",

            // Notification views.
            "js/views/NotificationView.coffee",
            "js/views/ConfirmationView.coffee",
            "js/views/SuccessView.coffee",
            "js/views/ErrorView.coffee",

            // User views.
            "js/views/UserView.coffee",
            "js/views/LoggedInView.coffee",
            "js/views/LoggedOutView.coffee",
            "js/views/LogInView.coffee",
            "js/views/NeedToSignUpView.coffee",
            "js/views/SignUpView.coffee",

            // Chart editing views.
            "js/views/ChartLoadingView.coffee",
            "js/views/ChartEditView.coffee",
            "js/views/ChartGraphicView.coffee",
            "js/views/ChartListView.coffee",
            "js/views/ParseErrorsView.coffee",
            "js/views/ChartTextView.coffee",
            "js/views/LibraryView.coffee",

            // Other dialogs.
            "js/views/AboutView.coffee",
            "js/views/AboutDialogView.coffee",
            "js/views/SVGPreviewView.coffee"
          ],
        }
      }
    },

    jade: {
      knitplot: {
        files: {
          "build/index.html": ["html/index.jade"]
        }
      }
    },

    concat: {
      js: {
        files: {
          "build/ext.js": [
            "ext/jquery-1.7.2.js",
            "ext/jquery-ui-1.8.21.custom.min.js",
            "ext/jquery.dotimeout.js",
            "ext/underscore-1.3.3.js",
            "ext/backbone-0.9.9.js",
            "ext/codemirror.js",
            "ext/codemirror-mode.js",
            "ext/raphael-2.1.0.js",
            "ext/parse-1.1.15.js"
          ]
        }
      },
      css: {
        files: {
          "build/knitplot.css": [
            "css/reset.css",
            "css/codemirror.css",
            "css/solarized.css",
            "css/ui-lightness/jquery-ui-1.8.21.custom.css",
            "css/knitplot.css"
          ]
        }
      }
    },

    copy: {
      images: {
        files: [
          { src: "images/*", dest: "build/" }
        ]
      }
    }
  });

  grunt.loadNpmTasks('grunt-contrib-coffee'); 
  grunt.loadNpmTasks('grunt-contrib-concat');
  grunt.loadNpmTasks('grunt-contrib-copy');
  grunt.loadNpmTasks('grunt-contrib-jade');

  grunt.registerTask('default', ['coffee', 'jade', 'concat', 'copy']);
};

