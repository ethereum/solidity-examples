"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
var chlk = require("chalk");
var io_1 = require("./io");
var jsondiffpatch = require("jsondiffpatch");
var constants_1 = require("../constants");
var path = require("path");
var chalk = chlk; // TODO Something going on with this thing.
var PASSED = chalk["greenBright"]("PASSED");
var FAILED = chalk["redBright"]("FAILED");
var WHITE_ARROW = chalk["white"]("->");
exports.printTestLog = function (jsonObj) {
    io_1.println('\n' + chalk["cyanBright"]("Test report") + '\n');
    io_1.println(chalk["bold"]["white"]('Context'));
    io_1.println((_a = ["\t{white Compiler version}: {magentaBright ", "}"], _a.raw = ["\\t{white Compiler version}: {magentaBright ", "}"], chalk(_a, jsonObj.solcVersion)));
    io_1.println((_b = ["\t{white EVM version}: {magentaBright ", "}"], _b.raw = ["\\t{white EVM version}: {magentaBright ", "}"], chalk(_b, jsonObj.evmVersion)));
    io_1.println(chalk["bold"]["white"]('Gas usage'));
    var results = jsonObj.results;
    for (var objName in results) {
        if (results.hasOwnProperty(objName)) {
            io_1.println((_c = ["\t{white ", "}: ", ""], _c.raw = ["\\t{white ", "}: ", ""], chalk(_c, objName, results[objName].passed ? PASSED : FAILED)));
        }
    }
    io_1.println('\n');
    var _a, _b, _c;
};
exports.printPerfLog = function (jsonObj) {
    io_1.println('\n' + chalk["cyanBright"]('Perf report') + '\n');
    io_1.println(chalk["bold"]["white"]('Context'));
    io_1.println((_a = ["\t{white Compiler version}: {magentaBright ", "}"], _a.raw = ["\\t{white Compiler version}: {magentaBright ", "}"], chalk(_a, jsonObj.solcVersion)));
    io_1.println((_b = ["\t{white EVM version}: {magentaBright ", "}"], _b.raw = ["\\t{white EVM version}: {magentaBright ", "}"], chalk(_b, jsonObj.evmVersion)));
    io_1.println(chalk["bold"]["white"]('Gas usage'));
    var results = jsonObj.results;
    for (var objName in results) {
        if (results.hasOwnProperty(objName)) {
            io_1.println((_c = ["\t{white ", "}: {blueBright ", "}"], _c.raw = ["\\t{white ", "}: {blueBright ", "}"], chalk(_c, objName, results[objName].gasUsed)));
        }
    }
    io_1.println('\n');
    var _a, _b, _c;
};
exports.diff = function (oldLog, newLog) { return jsondiffpatch["diff"](oldLog, newLog); };
exports.printPerfDiff = function (delta, oldLog, newLog) {
    io_1.println('\n' + chalk["cyanBright"]('Perf diff') + '\n');
    if (delta === undefined || delta === null) {
        io_1.println(chalk["greenBright"]('No changes'));
    }
    else {
        if (delta.solcVersion !== undefined || delta.evmVersion !== undefined) {
            io_1.println(chalk["bold"]["white"]('Context diff'));
            if (delta.solcVersion !== undefined) {
                io_1.println((_a = ["\t{white Compiler version}: {magentaBright ", " ", " ", "}"], _a.raw = ["\\t{white Compiler version}: {magentaBright ", " ", " ", "}"], chalk(_a, oldLog.solcVersion, WHITE_ARROW, newLog.solcVersion)));
            }
            if (delta.solcVersion !== undefined) {
                io_1.println((_b = ["\t{white EVM version}: {magentaBright ", " ", " ", "}"], _b.raw = ["\\t{white EVM version}: {magentaBright ", " ", " ", "}"], chalk(_b, oldLog.evmVersion, WHITE_ARROW, newLog.evmVersion)));
            }
        }
        if (delta.results !== undefined && Object.keys(delta).length > 0) {
            io_1.println(chalk["bold"]["white"]('Results'));
            var results = delta.results;
            for (var objName in results) {
                if (results.hasOwnProperty(objName)) {
                    var vDelta = results[objName];
                    if (vDelta instanceof Array && vDelta.length === 1) {
                        io_1.println((_c = ["\t({greenBright ++}) {white ", "}"], _c.raw = ["\\t({greenBright ++}) {white ", "}"], chalk(_c, objName)));
                    }
                    else if (vDelta instanceof Array && vDelta.length === 3) {
                        io_1.println((_d = ["\t({redBright --}) {white ", "}"], _d.raw = ["\\t({redBright --}) {white ", "}"], chalk(_d, objName)));
                    }
                    else {
                        var oldGas = vDelta.gasUsed[0];
                        var newGas = vDelta.gasUsed[1];
                        if (newGas > oldGas) {
                            io_1.println((_e = ["\t{white ", "}: ", " ", " ", ""], _e.raw = ["\\t{white ", "}: ", " ", " ", ""], chalk(_e, objName, chalk.blueBright(oldGas), WHITE_ARROW, chalk.redBright(newGas))));
                        }
                        else {
                            io_1.println((_f = ["\t{white ", "}: ", " ", " ", ""], _f.raw = ["\\t{white ", "}: ", " ", " ", ""], chalk(_f, objName, chalk.blueBright(oldGas), WHITE_ARROW, chalk.greenBright(newGas))));
                        }
                    }
                }
            }
        }
    }
    io_1.println('\n');
    var _a, _b, _c, _d, _e, _f;
};
exports.printLatestDiff = function (optimized) {
    if (optimized === void 0) { optimized = true; }
    var logFolders = io_1.indexedLogFolders(constants_1.PERF_LOGS_PATH, 2);
    if (logFolders.length < 2) {
        return false;
    }
    var file = optimized ? constants_1.RESULTS_NAME_OPTIMIZED : constants_1.RESULTS_NAME_UNOPTIMIZED;
    var newLog = io_1.readLog(path.join(constants_1.PERF_LOGS_PATH, logFolders[0]), file);
    var oldLog = io_1.readLog(path.join(constants_1.PERF_LOGS_PATH, logFolders[1]), file);
    var delta = exports.diff(oldLog, newLog);
    exports.printPerfDiff(delta, oldLog, newLog);
    return true;
};
