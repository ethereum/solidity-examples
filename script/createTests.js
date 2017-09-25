"use strict";
exports.__esModule = true;
var fs = require("fs");
var path = require("path");
var constants_1 = require("./constants");
var files_1 = require("./utils/files");
var solc_1 = require("./exec/solc");
var evm_1 = require("./exec/evm");
var logger_1 = require("./utils/logger");
var testLogger = logger_1.newTestLogger();
exports.testAll = function (extended, optAndUnopt) {
    var solcV = solc_1.version();
    var evmV = evm_1.version();
    files_1.ensureAndClear(constants_1.TEST_BIN);
    var tests = extended ? constants_1.UNITS_EXTENDED : constants_1.UNITS;
    var ret = exports.compileAndRunTests(tests, true);
    var log = {
        solcVersion: solcV,
        evmVersion: evmV,
        results: ret
    };
    var logsPath = files_1.createTimestampSubfolder(constants_1.TEST_LOGS);
    files_1.writeLog(log, logsPath, constants_1.RESULTS_NAME_OPTIMIZED);
    if (optAndUnopt) {
        files_1.ensureAndClear(constants_1.TEST_BIN);
        var retU = exports.compileAndRunTests(tests, false);
        var logU = {
            solcVersion: solcV,
            evmVersion: evmV,
            results: retU
        };
        files_1.writeLog(logU, logsPath, constants_1.RESULTS_NAME_UNOPTIMIZED);
    }
    if (!checkAndPresent(ret)) {
        throw new Error("One or more tests failed.");
    }
};
exports.compileAndRunTests = function (units, optimize) {
    for (var i = 0; i < units.length; i++) {
        var pckge = units[i][0];
        var test = units[i][1];
        solc_1.compileTest(pckge, test, optimize);
    }
    return exports.runTests(optimize);
};
exports.runTests = function (optimize) {
    var files = fs.readdirSync(constants_1.TEST_BIN);
    var sigfiles = files.filter(function (file) {
        var f = file.trim();
        return f.length > 4 && f.substr(0, 4) === 'Test' && f.split('.').pop() === 'signatures';
    });
    var results = {};
    for (var i = 0; i < sigfiles.length; i++) {
        var sigfile = sigfiles[i];
        if (!files_1.isSigInHashes(constants_1.TEST_BIN, sigfile, constants_1.TEST_FUN_HASH)) {
            throw new Error("No test function in signature file: " + sigfile);
        }
        var name_1 = sigfile.substr(0, sigfile.length - 11);
        var binRuntimePath = path.join(constants_1.TEST_BIN, name_1 + ".bin-runtime");
        var result = parseData(evm_1.run(binRuntimePath, constants_1.TEST_FUN_HASH));
        var throws = /Throws/.test(name_1);
        var passed = true;
        if (throws && result) {
            passed = false;
            console.error("Failed: Expected test to throw: " + name_1 + " (" + (optimize ? "optimized" : "unoptimized") + ")");
        }
        else if (!throws && !result) {
            passed = false;
            console.error("Failed: Expected test not to throw: " + name_1 + " (" + (optimize ? "optimized" : "unoptimized") + ")");
        }
        results[name_1] = { passed: passed };
    }
    return results;
};
var checkAndPresent = function (results) {
    var tests = 0;
    var failed = 0;
    testLogger.header('');
    testLogger.header('Running tests... ');
    testLogger.header('');
    for (var name_2 in results) {
        var res = results[name_2];
        tests++;
        if (res.passed) {
            testLogger.success(name_2 + ": PASSED");
        }
        else {
            failed++;
            testLogger.fail(name_2 + ": FAILED");
        }
    }
    testLogger.header('');
    testLogger.header("Ran " + tests + " tests.");
    if (failed !== 0) {
        testLogger.fail(failed + " tests FAILED.");
        return false;
    }
    else {
        testLogger.success("All tests PASSED");
        return true;
    }
};
var parseData = function (output) { return parseInt(output, 16) === 1; };
