// A simple server to compile the jade and coffee files on every request.

var child_process = require('child_process');
var express = require('express');
var fs = require('fs');
var jade = require('jade');

var app = express();

app.use(express.logger("dev"));

app.get("/js/knitplot.js", function(request, response) {
  child_process.exec("grunt", function(error, stdout, stderr) {
    if (error) {
      throw error;
    }
    console.log(stdout);
    console.error(stderr);
    fs.readFile("./js/knitplot.js", function(err, text) {
      response.set("Content-Type", "application/javascript");
      response.send(text);
    });
  });
});

app.get(/^(\/(css|js)\/(.*)\.(css|js|png))$/, function(request, response) {
  var path = "." + request.params[0];
  var type = {
    css: "text/css",
    png: "image/png",
    js: "application/javascript"
  }[request.params[3]] || "text/plain";

  fs.readFile(path, function(err, text) {
    response.set("Content-Type", type);
    response.send(text);
  });
});

app.get("/", function(request, response) {
  fs.readFile("./index.jade", function(err, jadeCode) {
    template = jade.compile(jadeCode, { filename: "./index.jade" });
    html = template();
    response.set("Content-Type", "text/html");
    response.send(html);
  });
});

app.listen(3000);
console.log("Listening on port 3000");

