"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
var fs = require("fs");
var path = require("path");
var constants_1 = require("./constants");
var files_1 = require("./utils/files");
var testeth_1 = require("./exec/testeth");
var solc_1 = require("./exec/solc");
var filler_1 = require("../script/utils/filler");
var mkdirp = require("mkdirp");
var generators = {};
exports.registerTests = function () {
    for (var i = 0; i < constants_1.UNITS.length; i++) {
        var gens = constants_1.UNITS[i][2];
        var tests = gens();
        for (var test in tests) {
            if (generators[test]) {
                throw new Error("Multiple generators for: ");
            }
            generators[test] = tests[test];
        }
    }
};
exports.testAll = function (optAndUnopt) {
    exports.registerTests();
    files_1.rmrf(constants_1.TESTS_PATH);
    files_1.rmrf(constants_1.FILLERS_PATH);
    mkdirp.sync(constants_1.FILLERS_PATH);
    files_1.rmrf(constants_1.TEST_BIN);
    mkdirp.sync(constants_1.TEST_BIN);
    exports.compileAndGenerateFillers(true);
    if (optAndUnopt) {
        files_1.rmrf(constants_1.TEST_BIN);
        fs.mkdirSync(constants_1.TEST_BIN);
        exports.compileAndGenerateFillers(false);
    }
    testeth_1.testeth();
};
exports.compileAndGenerateFillers = function (optimize) {
    for (var i = 0; i < constants_1.UNITS.length; i++) {
        var subDir = constants_1.UNITS[i][0];
        var test = constants_1.UNITS[i][1];
        solc_1.compileTest(subDir, test, false);
    }
    exports.generateFillers(optimize);
};
exports.generateFillers = function (optimize) {
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
        var binRuntime = fs.readFileSync(binRuntimePath).toString();
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
        var name_1 = testName + (optimize ? "Opt" : "Unopt");
        var code = '0x' + binRuntime;
        var filler = generators[testName] ? generators[testName](name_1, code) : filler_1.generateDefaultTestFiller(name_1, code);
        var fillerPath = path.join(constants_1.FILLERS_PATH, name_1 + "Filler.json");
        var fillerData = JSON.stringify(filler, null, '\t');
        fs.writeFileSync(fillerPath, fillerData);
    }
};
