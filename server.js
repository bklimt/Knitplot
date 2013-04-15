// A simple server to compile the jade and coffee files on every request.

var child_process = require('child_process');
var express = require('express');
var fs = require('fs');
var jade = require('jade');

var app = express();

app.use(express.logger("dev"));

app.get("/js/knitplot.js", function(request, response) {
  child_process.exec("grunt", function(error, stdout, stderr) {
    console.log(stdout);
    console.error(stderr);
    if (error) {
      throw error;
    }
    fs.readFile("./js/knitplot.js", function(err, text) {
      response.set("Content-Type", "application/javascript");
      response.send(text);
    });
  });
});

app.get(/^(\/(css|js|images)\/(.*)\.(css|js|png|gif))$/, function(request, response) {
  var path = "." + request.params[0];
  var type = {
    css: "text/css",
    gif: "image/gif",
    png: "image/png",
    js: "application/javascript"
  }[request.params[3]] || "text/plain";

  fs.readFile(path, function(err, text) {
    response.set("Content-Type", type);
    response.send(text);
  });
});

app.get("/", function(request, response) {
  child_process.exec("grunt", function(error, stdout, stderr) {
    console.log(stdout);
    console.error(stderr);
    if (error) {
      throw error;
    }
    fs.readFile("./index.html", function(err, text) {
      response.set("Content-Type", "text/html");
      response.send(text);
    });
  });
});

app.listen(3000);
console.log("Listening on port 3000");

