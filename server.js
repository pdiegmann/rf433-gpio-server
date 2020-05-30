var exec = require('child_process').exec;
var path = require('path');
var url = require('url') ;
var asyncQueue = require('async').queue;

var port = 8672;

process.argv.forEach(function (val, index, array) {
  if (val.indexOf("port=") == 0) {
    port = parseInt(val.split("=")[1]);
  }
});

const requestQueue = asyncQueue(function(task, callback) {
  var request = task.request;
  var response = task.response;

  console.log("task2: " + JSON.stringify(task.request.url));

  var queryObject = url.parse(request.url,true).query;
  //console.log("queryObject: " + JSON.stringify(queryObject));
  var execPath = queryObject.execPath;
  var pin = queryObject.pin;
  var systemCode = queryObject.systemCode;
  var unitCode = queryObject.unitCode;
  var powerState = queryObject.powerState == "true";

  var execCMD = [execPath,["--pin",pin].join('='),systemCode,unitCode,(powerState ? '1' : '0')].join(' ')
  //var execCMD = execPath + " " + systemCode + " " + unitCode + " " + (powerState ? '1' : '0')

  //console.log("query: " + request.url);
  console.log("exec: " + execCMD);

  exec(execCMD, function (error, stdout, stderr) {
    //setTimeout(function() {
    console.log("exec finished: " + stdout + " | " + stderr + " | " + error);
    callback();
    error = error || stderr;
    if(error) {
      response.statusCode = 500;
      response.end("Something went wrong 3: " + error);
    } else {
      response.end();
    }
    //}, 250);
  });
});

const http = require('http')

const requestHandler = function(request, response) {
  requestQueue.push({ request: request, response: response });
}

const server = http.createServer(requestHandler);
server.listen(port, function(error) {
  if (error) {
    return console.log('something went wrong 1: ', error);
  }

  console.log("server is listening on " +  port);
});
