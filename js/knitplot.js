// Generated by CoffeeScript 1.3.3
(function() {
  var ErrorView, Knitplot, NotificationView, Pattern, PatternEditView, PatternListView, Router,
    __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; },
    __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; };

  Pattern = (function(_super) {

    __extends(Pattern, _super);

    function Pattern() {
      return Pattern.__super__.constructor.apply(this, arguments);
    }

    Pattern.prototype.className = "Pattern";

    return Pattern;

  })(Parse.Object);

  NotificationView = (function(_super) {

    __extends(NotificationView, _super);

    function NotificationView() {
      this.render = __bind(this.render, this);

      this.initialize = __bind(this.initialize, this);
      return NotificationView.__super__.constructor.apply(this, arguments);
    }

    NotificationView.prototype.className = "success";

    NotificationView.prototype.initialize = function() {
      return this.render();
    };

    NotificationView.prototype.render = function() {
      var _ref,
        _this = this;
      $(this.el).html((_ref = this.options.message) != null ? _ref : "Success!");
      $(this.el).hide();
      $("#notification").html(this.el);
      $(this.el).slideDown();
      $.doTimeout(5000, function() {
        $(_this.el).slideUp();
        return $.doTimeout(2000, function() {
          return $(_this.el).remove();
        });
      });
      return this.delegateEvents();
    };

    return NotificationView;

  })(Parse.View);

  ErrorView = (function(_super) {

    __extends(ErrorView, _super);

    function ErrorView() {
      return ErrorView.__super__.constructor.apply(this, arguments);
    }

    ErrorView.prototype.className = "error";

    return ErrorView;

  })(NotificationView);

  PatternEditView = (function(_super) {

    __extends(PatternEditView, _super);

    function PatternEditView() {
      this.render = __bind(this.render, this);

      this.save = __bind(this.save, this);

      this.initialize = __bind(this.initialize, this);
      return PatternEditView.__super__.constructor.apply(this, arguments);
    }

    PatternEditView.prototype.events = {
      "submit form": "save"
    };

    PatternEditView.prototype.initialize = function() {
      this.model.bind("change", this.render);
      return this.render();
    };

    PatternEditView.prototype.save = function() {
      var _this = this;
      this.model.save({
        title: this.$('[name=title]').val(),
        text: this.$('[name=text]').val()
      }, {
        success: function() {
          new NotificationView({
            message: "Saved!"
          });
          return Backbone.history.saveLocation("documents/" + _this.model.id);
        },
        error: function() {
          return new ErrorView({
            message: "Unable to save."
          });
        }
      });
      return false;
    };

    PatternEditView.prototype.render = function() {
      var template;
      template = $("#pattern-template").html();
      $(this.el).html(_.template(template)({
        model: this.model
      }));
      $("#app").html(this.el);
      this.$("[name=title]").val(this.model.get("title"));
      this.$("[name=text]").val(this.model.get("text"));
      return this.delegateEvents();
    };

    return PatternEditView;

  })(Parse.View);

  PatternListView = (function(_super) {

    __extends(PatternListView, _super);

    function PatternListView() {
      this.render = __bind(this.render, this);

      this.initialize = __bind(this.initialize, this);
      return PatternListView.__super__.constructor.apply(this, arguments);
    }

    PatternListView.prototype.initialize = function() {
      this.start = this.options.start;
      return this.render();
    };

    PatternListView.prototype.render = function() {
      var template;
      template = $("#pattern-list-template").html();
      $(this.el).html(_.template(template)({
        collection: this.collection,
        start: this.start,
        previous: this.start - 10,
        next: this.start + 10
      }));
      $("#app").html(this.el);
      return this.delegateEvents();
    };

    return PatternListView;

  })(Parse.View);

  Router = (function(_super) {

    __extends(Router, _super);

    function Router() {
      this.listPatterns = __bind(this.listPatterns, this);

      this.editPattern = __bind(this.editPattern, this);

      this.newPattern = __bind(this.newPattern, this);
      return Router.__super__.constructor.apply(this, arguments);
    }

    Router.prototype.routes = {
      "": "listPatterns",
      "new": "newPattern",
      "pattern/:id": "editPattern",
      "patterns/:start": "listPatterns"
    };

    Router.prototype.newPattern = function() {
      return new PatternEditView({
        model: new Pattern()
      });
    };

    Router.prototype.editPattern = function(id) {
      var pattern,
        _this = this;
      pattern = new Pattern({
        objectId: id
      });
      return pattern.fetch({
        success: function() {
          return new PatternEditView({
            model: pattern
          });
        },
        error: function(pattern, error) {
          new Error({
            message: "Count not find the pattern."
          });
          return window.location.hash = "#";
        }
      });
    };

    Router.prototype.listPatterns = function(start) {
      var patterns, query,
        _this = this;
      if (start == null) {
        start = 0;
      }
      query = new Parse.Query(Pattern);
      query.descending("updatedAt", "createdAt").skip(start).limit(10);
      patterns = query.collection();
      return patterns.fetch({
        success: function() {
          return new PatternListView({
            collection: patterns,
            start: parseInt(start)
          });
        },
        error: function(patterns, error) {
          return new Error({
            message: "Unable to load patterns."
          });
        }
      });
    };

    return Router;

  })(Backbone.Router);

  Knitplot = {
    init: function() {
      Parse.initialize("732uFxOqiBozGHcv6BUyEZrpQC0oIbmTbi4UJuK2", "JB48tpHfZ39NTwrRuQIoqq7GQzpdxLonrjpsj67L");
      new Router();
      return Backbone.history.start();
    }
  };

  window.App = Knitplot;

}).call(this);
