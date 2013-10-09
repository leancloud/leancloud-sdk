var AV = require('avoscloud-sdk').AV;
var underscore = require('underscore');
var http = require('http');
var https = require('https');
var urlParser = require('url');
var querystring = require('querystring');
var util = require('util');
var express = require('express');
var path = require('path');
var fs = require('fs');
var _ = require('underscore');

var _ref, _ref1;
if ((_ref = https.globalAgent) != null) {
	if ((_ref1 = _ref.options) != null) {
		_ref1.rejectUnauthorized = false;
	}
}


function MockRequest(object, params, user){
	this.object = object;
	this.params = params || object;
    this.user = user;
}


function MockResponse(options){
	this._options = options;
}

MockResponse.prototype = {
	success: function(data){
		this._options.success(data);
	},
    error: function(err){
		this._options.error(err);
	}
}

exports.MockRequest = MockRequest
exports.MockResponse = MockResponse

//Mock functions in cloud code.

//Mock http request
var className = function(clazz) {
	if (underscore.isString(clazz)) {
		return clazz;
	}
	if (clazz.className != null) {
		return clazz.className;
	}
	throw "Unknown class:" + clazz;
};

//Mock functions
var funcs = {};
AV.Cloud.define = function(name, func){
	funcs[name] = func;
};
AV.Cloud.beforeSave = function(name, func){
	funcs[className(name) + "_beforeSave"] = func;
};
AV.Cloud.afterSave = function(name, func){
	funcs[className(name) + "_afterSave"] = func;
};
AV.Cloud.afterUpdate = function(name, func){
	funcs[className(name) + "_afterUpdate"] = func;
};
AV.Cloud.beforeDelete = function(name, func){
	funcs[className(name) + "_beforeDelete"] = func;
};
AV.Cloud.afterDelete = function(name, func){
	funcs[className(name) + "_afterDelete"] = func;
};

function runFunc(name, req, res){
	if(!funcs[name])
		throw "Could not find function:" + name;
    funcs[name].call(this, req, res);
}
function runBeforeSave(name, req, res){
	runFunc(className(name) + "_beforeSave", req, res);
}
function runAfterSave(name, req, res){
	runFunc(className(name) + "_afterSave", req, res);
}
function runAfterUpdate(name, req, res){
	runFunc(className(name) + "_afterUpdate", req, res);
}
function runBeforeDelete(name, req, res){
	runFunc(className(name) + "_beforeDelete", req, res);
}
function runAfterDelete(name, req, res){
	runFunc(className(name) + "_afterDelete", req, res);
}

exports.runFunc = runFunc
exports.runBeforeSave = runBeforeSave
exports.runAfterSave  = runAfterSave
exports.runAfterUpdate = runAfterUpdate
exports.runBeforeDelete = runBeforeDelete
exports.runAfterDelete = runAfterDelete

AV.Cloud.httpRequest = function(options) {
	var body, headers, hostname, httpResponse, http_module, method, params, parsedRes, path, port, promise, request, requestOptions, search, url;

	options = options || {};
	options.agent = false;
	url = options.url;
	http_module = /^https.*/.exec(url) ? https : http;
	promise = new AV.Promise();
	params = options.params;
	headers = options.headers || "";
	method = options.method || "GET";
	body = options.body;
	parsedRes = urlParser.parse(url);
	hostname = parsedRes.hostname;
	port = parsedRes.port || 80;
	path = parsedRes.path;
	search = parsedRes.search;
	if (params != null) {
		path = search == null ? path + '?' : path + '&';
		if (typeof params === 'string') {
			params = querystring.parse(params);
		}
		params = querystring.stringify(params);
		path = path + params;
	}
	requestOptions = {
		host: hostname,
		port: port,
		method: method,
		headers: headers,
		path: path
	};
	httpResponse = new HTTPResponse;
	request = http_module.request(requestOptions, function(res) {
		var chunkList, contentLength;

		httpResponse.status = res.statusCode;
		httpResponse.text = '';
		chunkList = [];
		contentLength = 0;
		res.on('data', function(chunk) {
			httpResponse.text += chunk.toString();
			contentLength += chunk.length;
			return chunkList.push(chunk);
		});
		return res.on('end', function() {
			var chunk, pos, _i, _len;

			httpResponse.buffer = new Buffer(contentLength);
			pos = 0;
			for (_i = 0, _len = chunkList.length; _i < _len; _i++) {
				chunk = chunkList[_i];
				chunk.copy(httpResponse.buffer, pos);
				pos += chunk.length;
			}
			if (httpResponse.status < 200 || httpResponse.status >= 400) {
				return promise.reject(httpResponse);
			} else {
				return promise.resolve(httpResponse);
			}
		});
	});
	request.on('error', function(e) {
		httpResponse.text = util.inspect(e);
		httpResponse.status = 500;
		return promise.reject(httpResponse);
	});
	request.end(body);
	return promise._thenRunCallbacks(options);
};

//initialize SDK.
var globalJSON = fs.readFileSync('./config/global.json', 'utf-8')
var data = JSON.parse(globalJSON);
AV.initialize(data.applicationId, data.applicationKey);

//Mock express
var Module = module.constructor;
var paths = module.paths;
function requireFromString(src, filename) {
	var m = new Module();
	m.paths = module.paths;
	m._compile("var AV = require('avoscloud-sdk').AV; \n" + src, filename);
	return m.exports;
}

Global = {}
Module.prototype.require = function(id) {
	if(id.match(/^cloud\//)){
		id = "./" + id;
		return requireFromString(fs.readFileSync(require.resolve(id), 'utf-8'), id);
	}
	result = Module._load(id, this);
    if(id == 'express'){
		oldExpress = result;
		result = function(){
			var app = oldExpress();
			app.__listen = app.listen;
			app.listen =  function(){
				var configDir, jsonFile, publicDir, views;
				jsonFile = require.resolve('./config/global.json');
				configDir = path.dirname(jsonFile);
				views = path.resolve(configDir, '../' + (this.get('views')));
				publicDir = path.resolve(configDir, '../public');
				this.set('views', views);
				this.use(oldExpress["static"](publicDir));
				this.use(function(err, req, res, next) {
					if (err != null) {
						console.error("Error occured:" + err);
						return res.send(err);
					} else {
						return next();
					}
				});
				return this;
			};
			Global.app = app;
			return app;
		};
		result = _.extend(result, oldExpress);
	}
	return result;
};

function processRequest(type, req, res){
	if(type == 'object'){
		var func = req.params.func;
		var object = new AV.Object(className);
		var className = req.params.className;
		object._finishFetch(req.body, true);
		var mockReq = new MockRequest(object);
		var mockResp =new MockResponse({
			success: function(data){
				res.send(data);
			},
			error: function(err){
				res.statusCode = 500;
				console.log("Error occured:" + err);
				res.send("Error:" + err);
			}
		});
		var target = null;
		switch(func){
		case "beforeSave":
			target = runBeforeSave;
			break;
		case "afterSave":
			target = runAfterSave;
			break;
		case "afterUpdate":
			target = runAfterUpdate;
			break;
		case "beforeDelete":
			target = runBeforeDelete;
			break;
		case "afterDelete":
			target = runAfterDelete;
			break;
		default:
			throw "Could not find function:" + func;
		}
		target.call(this, className, mockReq, mockResp);
	}else{
		var mockReq = new MockRequest(null, req.body);
		var mockResp =new MockResponse({
			success: function(data){
				res.send(data);
			},
			error: function(err){
				res.statusCode = 500;
				console.log("Error occured:" + err);
				res.send("Error:" + err);
			}
		});
		runFunc(req.params.name, mockReq, mockResp);
	}
}

exports.runCloudCode = function(id){
	var cloudPath = path.resolve(id);
	requireFromString(fs.readFileSync(cloudPath, 'utf-8'), id);
	var app = Global.app;
	if(!app){
		app = express();
	}
	var port = app.port || 3000;
	app.post("/avos/:className/:func", function(req, res){
		processRequest('object', req, res);
	});
	app.post("/avos/:name", function(req, res){
		processRequest("function", req, res);
	});
	console.log(funcs);
	app.__listen(port, function() {
		return console.log("Listening on " + port + "\nPress CTRL-C to stop server.");
	});
}