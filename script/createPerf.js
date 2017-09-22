"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
var fs = require("fs");
var path = require("path");
var constants_1 = require("./constants");
var files_1 = require("./utils/files");
var solc_1 = require("./exec/solc");
var ethvm_1 = require("./exec/ethvm");
var mkdirp = require("mkdirp");
var jsondiffpatch = require("jsondiffpatch");
exports.perfAll = function (optAndUnopt) {
    var solcV = solc_1.version().split(/\r\n|\r|\n/)[1].trim();
    var ethvmV = ethvm_1.version().split(/\r\n|\r|\n/)[0].trim();
    files_1.rmrf(constants_1.PERF_BIN);
    mkdirp.sync(constants_1.PERF_BIN);
    var folder = new Date().getTime().toString(10);
    var logPath = path.join(constants_1.PERF_LOGS, folder);
    var ret = exports.compileAndRunPerf(true);
    var log = {
        solcVersion: solcV,
        ethvmVersion: ethvmV,
        results: ret
    };
    var logStr = JSON.stringify(log, null, '\t');
    mkdirp.sync(logPath);
    var optResultsPath = path.join(logPath, "results_optimized.json");
    fs.writeFileSync(optResultsPath, logStr);
    console.log("Logs printed to: " + optResultsPath);
    var logU = null;
    if (optAndUnopt) {
        files_1.rmrf(constants_1.PERF_BIN);
        mkdirp.sync(constants_1.PERF_BIN);
        var retU = exports.compileAndRunPerf(false);
        logU = {
            solcVersion: solcV,
            ethvmVersion: ethvmV,
            results: retU
        };
        var logStrU = JSON.stringify(logU, null, '\t');
        var unoptResultsPath = path.join(logPath, "results_unoptimized.json");
        fs.writeFileSync(unoptResultsPath, logStrU);
        console.log("Logs printed to: " + optResultsPath);
    }
    var latestFile = path.join(constants_1.PERF_LOGS, 'latest');
    if (fs.existsSync(latestFile)) {
        var latest = fs.readFileSync(latestFile).toString();
        var latestOptStr = fs.readFileSync(path.join(constants_1.PERF_LOGS, latest, "results_optimized.json")).toString();
        var latestOptResults = JSON.parse(latestOptStr);
        var diff = jsondiffpatch.diff(latestOptResults, log);
        if (diff) {
            var output = jsondiffpatch.formatters.console.format(diff);
            console.log("Changes since last run:");
            console.log(output);
        }
        if (optAndUnopt) {
            var latestUnOptFile = path.join(constants_1.PERF_LOGS, latest, "results_unoptimized.json");
            if (fs.existsSync(latestUnOptFile)) {
                var latestUnOptStr = fs.readFileSync(latestUnOptFile).toString();
                var latestUnOptResults = JSON.parse(latestUnOptStr);
                var diff_1 = jsondiffpatch.diff(latestUnOptResults, logU);
                if (diff_1) {
                    var output = jsondiffpatch.formatters.console.format(diff_1);
                    console.log("Changes since last run:");
                    console.log(output);
                }
            }
        }
    }
    fs.writeFileSync(latestFile, folder);
};
exports.compileAndRunPerf = function (optimize) {
    for (var i = 0; i < constants_1.UNITS.length; i++) {
        var subDir = constants_1.UNITS[i][0];
        var test = constants_1.UNITS[i][1];
        solc_1.compilePerf(subDir, test, optimize);
    }
    return exports.runPerf();
};
exports.runPerf = function () {
    var files = fs.readdirSync(constants_1.PERF_BIN);
    var sigfiles = files.filter(function (file) {
        var f = file.trim();
        return f.length > 4 && f.substr(0, 4) === 'Perf' && f.split('.').pop() === 'signatures';
    });
    var log = {};
    for (var j = 0; j < sigfiles.length; j++) {
        var sigfile = sigfiles[j];
        var perfName = sigfile.substr(0, sigfile.length - 11);
        var binRuntimePath = path.join(constants_1.PERF_BIN, perfName + ".bin-runtime");
        var hashesPath = path.join(constants_1.PERF_BIN, sigfile);
        var binRuntime = fs.readFileSync(binRuntimePath).toString();
        var hashes = fs.readFileSync(hashesPath).toString();
        var lines = hashes.split(/\r\n|\r|\n/);
        if (lines.length === 0) {
            throw new Error("No methods in: " + perfName);
        }
        var perfFound = false;
        for (var i = 0; i < lines.length; i++) {
            var line = lines[i].trim();
            if (line.length === 0) {
                continue;
            }
            var tokens = line.split(':');
            if (tokens.length !== 2) {
                throw new Error("No : separator in line: " + line);
            }
            var hash = tokens[0].trim();
            if (hash === constants_1.PERF_FUN_HASH) {
                if (perfFound) {
                    throw new Error("Repeated hash of perf function in file: " + hashes);
                }
                perfFound = true;
            }
        }
        if (!perfFound) {
            throw new Error("Contract has no perf: " + hashes);
        }
        var code = '0x' + binRuntime;
        var result = ethvm_1.perf(code);
        log[perfName] = parseData(result);
    }
    return log;
};
var parseData = function (output) {
    var lines = output.split(/\r\n|\r|\n/);
    if (lines[0].indexOf('Gas used') !== 0) {
        throw new Error("Malformed ethvm output (line 1):\n " + output);
    }
    // Output
    if (lines[1].indexOf('Output:') !== 0) {
        throw new Error("Malformed ethvm output (line 2):\n " + output);
    }
    var outputSplit = lines[1].split(':');
    if (outputSplit.length !== 2) {
        throw new Error("Malformed ethvm output (line 2):\n " + output);
    }
    var gasUsed = parseInt(outputSplit[1].trim(), 16);
    return {
        gasUsed: gasUsed || 0
    };
};
