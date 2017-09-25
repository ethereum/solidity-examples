"use strict";
exports.__esModule = true;
var fs = require("fs");
var path = require("path");
var constants_1 = require("./constants");
var files_1 = require("./utils/files");
var solc_1 = require("./exec/solc");
var evm_1 = require("./exec/evm");
var jsondiffpatch = require("jsondiffpatch");
exports.perfAll = function (optAndUnopt) {
    if (optAndUnopt === void 0) { optAndUnopt = false; }
    // Set up paths and check versions of the required tools.
    var solcV = solc_1.version();
    var evmV = evm_1.version();
    files_1.ensureAndClear(constants_1.PERF_BIN);
    var ret = exports.compileAndRunPerf(constants_1.UNITS, true);
    var log = {
        solcVersion: solcV,
        evmVersion: evmV,
        results: ret
    };
    var logsPath = files_1.createTimestampSubfolder(constants_1.PERF_LOGS);
    files_1.writeLog(log, logsPath, constants_1.RESULTS_NAME_OPTIMIZED);
    // If unoptimized is enabled.
    if (optAndUnopt) {
        files_1.ensureAndClear(constants_1.PERF_BIN);
        var retU = exports.compileAndRunPerf(constants_1.UNITS, false);
        var logU = {
            solcVersion: solcV,
            evmVersion: evmV,
            results: retU
        };
        files_1.writeLog(logU, logsPath, constants_1.RESULTS_NAME_UNOPTIMIZED);
    }
    // Diffs
    var latest = files_1.readLatest(constants_1.PERF_LOGS);
    if (latest !== '') {
        var latestResults = files_1.readLog(latest, constants_1.RESULTS_NAME_OPTIMIZED);
        var diff = jsondiffpatch.diff(latestResults, log);
        if (diff) {
            var output = jsondiffpatch.formatters.console.format(diff);
            console.log("Changes since last run:");
            console.log(output);
        }
    }
    files_1.writeLatest(constants_1.PERF_LOGS, logsPath);
};
exports.compileAndRunPerf = function (units, optimize) {
    for (var i = 0; i < units.length; i++) {
        var subDir = units[i][0];
        var perf = units[i][1];
        solc_1.compilePerf(subDir, perf, optimize);
    }
    return exports.runPerf();
};
exports.runPerf = function () {
    var files = fs.readdirSync(constants_1.PERF_BIN);
    var sigfiles = files.filter(function (file) {
        var f = file.trim();
        return f.length > 4 && f.substr(0, 4) === 'Perf' && f.split('.').pop() === 'signatures';
    });
    var results = {};
    for (var i = 0; i < sigfiles.length; i++) {
        var sigfile = sigfiles[i];
        if (!files_1.isSigInHashes(constants_1.PERF_BIN, sigfile, constants_1.PERF_FUN_HASH)) {
            throw new Error("No perf function in signature file: " + sigfile);
        }
        var name_1 = sigfile.substr(0, sigfile.length - 11);
        var binRuntimePath = path.join(constants_1.PERF_BIN, name_1 + ".bin-runtime");
        var result = evm_1.run(binRuntimePath, constants_1.PERF_FUN_HASH);
        var gasUsed = parseData(result);
        results[name_1] = { gasUsed: gasUsed };
    }
    return results;
};
var parseData = function (output) { return parseInt(output, 16); };
