"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
var fs = require("fs");
var path = require("path");
var constants_1 = require("./constants");
var files_1 = require("./utils/files");
var solc_1 = require("./exec/solc");
var mkdirp = require("mkdirp");
var evm_1 = require("./exec/evm");
exports.testAll = function (optAndUnopt) {
    files_1.rmrf(constants_1.TEST_BIN);
    mkdirp.sync(constants_1.TEST_BIN);
    exports.compileAndRunTests(true);
    if (optAndUnopt) {
        files_1.rmrf(constants_1.TEST_BIN);
        mkdirp.sync(constants_1.TEST_BIN);
        exports.compileAndRunTests(false);
    }
};
exports.compileAndRunTests = function (optimize) {
    for (var i = 0; i < constants_1.UNITS.length; i++) {
        var subDir = constants_1.UNITS[i][0];
        var test_1 = constants_1.UNITS[i][1];
        solc_1.compileTest(subDir, test_1, false);
    }
    exports.runTests(optimize);
};
exports.runTests = function (optimize) {
    var files = fs.readdirSync(constants_1.TEST_BIN);
    var sigfiles = files.filter(function (file) {
        var f = file.trim();
        return f.length > 4 && f.substr(0, 4) === 'Test' && f.split('.').pop() === 'signatures';
    });
    for (var j = 0; j < sigfiles.length; j++) {
        var sigfile = sigfiles[j];
        var testName = sigfile.substr(0, sigfile.length - 11);
        var binRuntimePath = path.join(constants_1.TEST_BIN, testName + ".bin-runtime");
        var hashesPath = path.join(constants_1.TEST_BIN, sigfile);
        var hashes = fs.readFileSync(hashesPath).toString();
        var lines = hashes.split(/\r\n|\r|\n/);
        if (lines.length === 0) {
            throw new Error("No methods in: " + testName);
        }
        var testFound = false;
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
            if (hash === constants_1.TEST_FUN_HASH) {
                if (testFound) {
                    throw new Error("Repeated hash of test function in file: " + hashes);
                }
                testFound = true;
            }
        }
        if (!testFound) {
            throw new Error("Contract has no test: " + hashes);
        }
        var throws = /Throws/.test(testName);
        var result = parseData(evm_1.test(binRuntimePath));
        if (throws && result) {
            throw new Error("Failed: Expected test to throw: " + testName + " (" + (optimize ? "optimized" : "unoptimized") + ")");
        }
        if (!throws && !result) {
            throw new Error("Failed: Expected test not to throw: " + testName + " (" + (optimize ? "optimized" : "unoptimized") + ")");
        }
    }
    console.log("Successfully ran " + sigfiles.length + " tests.");
};
var parseData = function (output) { return parseInt(output.trim(), 16) === 1; };
