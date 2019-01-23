var express = require('express');
var fs = require('fs');
var request = require('request');
var cheerio = require('cheerio');
var app = express();
var osc = require('node-osc');
var dgram = require('dgram');
var net = require('net')
var client = dgram.createSocket('udp4');
var clientN = new net.Socket();


var username=''
var password='1337'

var counter1 = 0;
var counter2 = 0;
var counter3 = 0;
var counter4 = 0;


/*
clientN.connect(50000, '127.0.0.1', function() {
	console.log('Connected');
	
	url =  'http://127.0.0.1:50000/requests/status.xml'
	request(url, { json: true }, (err, res, body) => {
  if (err) { return console.log(err); }
  console.log(body.url);
  console.log(body.explanation);
});
	request(url, function(error, response, html){})
	clientN.write('Help');
});
*/
var oscServer = new osc.Server(12000, '0.0.0.0');
oscServer.on("/wek/outputs", function (msg, rinfo) {
      console.log("OSC message:");
      console.log(msg[1]);
	  selector = msg[1]
	  
	  if (selector === 1){
		counter1 = counter1+1
		console.log('count')
		console.log(counter1)
		if (counter1 >10){
			counter1 = -10;
			counter2 = 0;
			counter3 = 0;
			counter4 = 0;

		}
		
	  }
	  if (selector === 2){
		counter2 = counter2+1
		console.log(counter2)
		if (counter2 >10){
			counter1 = 0;
			counter2 = -10;
			counter3 = 0;
			counter4 = 0;
			var options = {
				url: 'http://127.0.0.1:8080/requests/status.xml?command=pl_previous',
				auth: {
					user: username,
					password: password
				}
			}		
			request(options, (err, res, body) => {
			  if (err) { return console.log(err); }
			  //console.log(body.url);
			  //console.log(body.explanation);
			});
		}
	  }
	  if (selector === 3){
		counter3 = counter3+1
		console.log(counter3)
		if (counter3 >10){
			counter1 = 0;
			counter2 = 0;
			counter3 = -10;
			counter4 = 0;
			var options = {
				url: 'http://127.0.0.1:8080/requests/status.xml?command=pl_next',
				auth: {
					user: username,
					password: password
				}
			}		
			request(options, (err, res, body) => {
			  if (err) { return console.log(err); }
			  //console.log(body.url);
			  //console.log(body.explanation);
			});
		}
	  }
	  if (selector === 4){
		counter4 = counter4+1
		console.log(counter4)
		if (counter4 >10){
			counter1 = 0;
			counter2 = 0;
			counter3 = 0;
			counter4 = -10;
			var options = {
				url: 'http://127.0.0.1:8080/requests/status.xml?command=pl_pause',
				auth: {
					user: username,
					password: password
				}
			}		
			request(options, (err, res, body) => {
			  if (err) { return console.log(err); }
			  //console.log(body.url);
			  //console.log(body.explanation);
			});
		}
	  }	  
	  /*
	  var options = {
		url: 'http://127.0.0.1:8080/requests/status.xml?command=pl_pause',
		auth: {
			user: username,
			password: password
		}
	  }		
	  request(options, (err, res, body) => {
		  if (err) { return console.log(err); }
		  //console.log(body.url);
		  //console.log(body.explanation);
		});
*/
});


//app.listen('8081')

//console.log('Magic happens on port 8081');
console.log('listening on port 12000')
exports = module.exports = app;