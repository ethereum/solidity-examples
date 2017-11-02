"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
var fs = require("fs");
var mkdirp = require("mkdirp");
var path = require("path");
var logger_1 = require("./logger");
var constants_1 = require("../constants");
exports.print = function (text) {
    process.stdout.write(text);
};
exports.println = function (text) {
    process.stdout.write(text + '\n');
};
exports.readText = function (filePath) {
    return fs.readFileSync(filePath).toString();
};
exports.readJSON = function (filePath) {
    return JSON.parse(exports.readText(filePath));
};
exports.rmrf = function (pth) {
    if (fs.existsSync(pth)) {
        fs.readdirSync(pth).forEach(function (file) {
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
exports.readLog = function (dir, name) { return exports.readJSON(path.join(dir, name)); };
exports.latestPerfLog = function (optimized) {
    if (optimized === void 0) { optimized = true; }
    var latest = exports.readLatest(constants_1.PERF_LOGS_PATH);
    if (latest === '') {
        throw new Error("No perf-logs found.");
    }
    var file = optimized ? constants_1.RESULTS_NAME_OPTIMIZED : constants_1.RESULTS_NAME_UNOPTIMIZED;
    return exports.readLog(latest, file);
};
exports.latestTestLog = function (optimized) {
    if (optimized === void 0) { optimized = true; }
    var latest = exports.readLatest(constants_1.TEST_LOGS_PATH);
    if (latest === '') {
        throw new Error("No test-logs found.");
    }
    var file = optimized ? constants_1.RESULTS_NAME_OPTIMIZED : constants_1.RESULTS_NAME_UNOPTIMIZED;
    return exports.readLog(latest, file);
};
exports.indexedLogFolders = function (baseDir, maxEntries) {
    if (maxEntries === void 0) { maxEntries = 20; }
    var files = fs.readdirSync(baseDir);
    var logFolders = files.filter(function (file) {
        if (!fs.statSync(path.join(baseDir, file)).isDirectory()) {
            return false;
        }
        var num = parseInt(file, 10);
        return !isNaN(num) && num > 0;
    }).sort().reverse();
    return logFolders.length > maxEntries ? logFolders.slice(0, maxEntries) : logFolders;
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
