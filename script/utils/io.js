"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
var fs = require("fs");
var mkdirp = require("mkdirp");
var path = require("path");
var logger_1 = require("./logger");
exports.print = function (text) {
    process.stdout.write(text);
};
exports.println = function (text) {
    process.stdout.write(text + '\n');
};
exports.readText = function (filePath) {
    return fs.readFileSync(filePath).toString();
};
exports.rmrf = function (pth) {
    if (fs.existsSync(pth)) {
        fs.readdirSync(pth).forEach(function (file, index) {
            var curPath = pth + "/" + file;
            if (fs.lstatSync(curPath).isDirectory()) {
                exports.rmrf(curPath);
            }
            else {
                fs.unlinkSync(curPath);
            }
        });
        fs.rmdirSync(pth);
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
exports.readLatest = function (dir) {
    var latestFile = path.join(dir, 'latest');
    if (!fs.existsSync(latestFile)) {
        return "";
    }
    return fs.readFileSync(latestFile).toString();
};
exports.writeLatest = function (dir, data) {
    var latestFile = path.join(dir, 'latest');
    if (!fs.existsSync(latestFile)) {
        mkdirp.sync(dir);
    }
    fs.writeFileSync(latestFile, data);
};
exports.writeLog = function (log, dir, name) {
    var optResultsPath = path.join(dir, name);
    fs.writeFileSync(optResultsPath, JSON.stringify(log, null, '\t'));
    logger_1.default.info("Logs written to: " + optResultsPath);
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
    for (var _i = 0, lines_1 = lines; _i < lines_1.length; _i++) {
        var line = lines_1[_i];
        line = line.trim();
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
            perfFound = true;
        }
    }
    return perfFound;
};
