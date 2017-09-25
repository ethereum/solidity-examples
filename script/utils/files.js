"use strict";
exports.__esModule = true;
var fs = require("fs");
var mkdirp = require("mkdirp");
var path = require("path");
exports.rmrf = function (path) {
    if (fs.existsSync(path)) {
        fs.readdirSync(path).forEach(function (file, index) {
            var curPath = path + "/" + file;
            if (fs.lstatSync(curPath).isDirectory()) {
                exports.rmrf(curPath);
            }
            else {
                fs.unlinkSync(curPath);
            }
        });
        fs.rmdirSync(path);
    }
};
exports.ensureAndClear = function (dir) {
    exports.rmrf(dir);
    mkdirp.sync(dir);
};
exports.createTimestampSubfolder = function (root) {
    var folder = new Date().getTime().toString(10);
    var logPath = path.join(root, folder);
    mkdirp.sync(logPath);
    return logPath;
};
exports.writeLog = function (log, dir, name) {
    var optResultsPath = path.join(dir, name);
    fs.writeFileSync(optResultsPath, JSON.stringify(log, null, '\t'));
    console.info("Logs written to: " + optResultsPath);
};
exports.readLog = function (dir, name) {
    var latestOptStr = fs.readFileSync(path.join(dir, name)).toString();
    return JSON.parse(latestOptStr);
};
exports.isSigInHashes = function (dir, sigfile, sig) {
    var hashes = fs.readFileSync(path.join(dir, sigfile)).toString();
    var lines = hashes.split(/\r\n|\r|\n/);
    if (lines.length === 0) {
        throw new Error("No methods found in signatures: " + sigfile);
    }
    var perfFound = false;
    for (var i = 0; i < lines.length; i++) {
        var line = lines[i].trim();
        if (line.length === 0) {
            continue;
        }
        var tokens = line.split(':');
        if (tokens.length !== 2) {
            throw new Error("No ':' separator in line: '" + line + "' in signatures: " + sigfile);
        }
        var hash = tokens[0].trim();
        if (hash === sig) {
            if (perfFound) {
                throw new Error("Repeated hash of perf function in signature file: " + sigfile);
            }
            return true;
        }
    }
    return false;
};
