"use strict";
var __makeTemplateObject = (this && this.__makeTemplateObject) || function (cooked, raw) {
    if (Object.defineProperty) { Object.defineProperty(cooked, "raw", { value: raw }); } else { cooked.raw = raw; }
    return cooked;
};
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
    io_1.println(chalk(templateObject_1 || (templateObject_1 = __makeTemplateObject(["\t{white Compiler version}: {magentaBright ", "}"], ["\\t{white Compiler version}: {magentaBright ", "}"])), jsonObj.solcVersion));
    io_1.println(chalk(templateObject_2 || (templateObject_2 = __makeTemplateObject(["\t{white EVM version}: {magentaBright ", "}"], ["\\t{white EVM version}: {magentaBright ", "}"])), jsonObj.evmVersion));
    io_1.println(chalk["bold"]["white"]('Test results'));
    var results = jsonObj.results;
    for (var objName in results) {
        if (results.hasOwnProperty(objName)) {
            io_1.println(chalk(templateObject_3 || (templateObject_3 = __makeTemplateObject(["\t{white ", "}: ", ""], ["\\t{white ", "}: ", ""])), objName, results[objName].passed ? PASSED : FAILED));
        }
    }
    io_1.println('\n');
};
exports.printPerfLog = function (jsonObj) {
    io_1.println('\n' + chalk["cyanBright"]('Perf report') + '\n');
    io_1.println(chalk["bold"]["white"]('Context'));
    io_1.println(chalk(templateObject_4 || (templateObject_4 = __makeTemplateObject(["\t{white Compiler version}: {magentaBright ", "}"], ["\\t{white Compiler version}: {magentaBright ", "}"])), jsonObj.solcVersion));
    io_1.println(chalk(templateObject_5 || (templateObject_5 = __makeTemplateObject(["\t{white EVM version}: {magentaBright ", "}"], ["\\t{white EVM version}: {magentaBright ", "}"])), jsonObj.evmVersion));
    io_1.println(chalk["bold"]["white"]('Gas usage'));
    var results = jsonObj.results;
    for (var objName in results) {
        if (results.hasOwnProperty(objName)) {
            io_1.println(chalk(templateObject_6 || (templateObject_6 = __makeTemplateObject(["\t{white ", "}: {blueBright ", "}"], ["\\t{white ", "}: {blueBright ", "}"])), objName, results[objName].gasUsed));
        }
    }
    io_1.println('\n');
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
                io_1.println(chalk(templateObject_7 || (templateObject_7 = __makeTemplateObject(["\t{white Compiler version}: {magentaBright ", " ", " ", "}"], ["\\t{white Compiler version}: {magentaBright ", " ", " ", "}"])), oldLog.solcVersion, WHITE_ARROW, newLog.solcVersion));
            }
            if (delta.solcVersion !== undefined) {
                io_1.println(chalk(templateObject_8 || (templateObject_8 = __makeTemplateObject(["\t{white EVM version}: {magentaBright ", " ", " ", "}"], ["\\t{white EVM version}: {magentaBright ", " ", " ", "}"])), oldLog.evmVersion, WHITE_ARROW, newLog.evmVersion));
            }
        }
        if (delta.results !== undefined && Object.keys(delta).length > 0) {
            io_1.println(chalk["bold"]["white"]('Results'));
            var results = delta.results;
            for (var objName in results) {
                if (results.hasOwnProperty(objName)) {
                    var vDelta = results[objName];
                    if (vDelta instanceof Array && vDelta.length === 1) {
                        io_1.println(chalk(templateObject_9 || (templateObject_9 = __makeTemplateObject(["\t({greenBright ++}) {white ", "}"], ["\\t({greenBright ++}) {white ", "}"])), objName));
                    }
                    else if (vDelta instanceof Array && vDelta.length === 3) {
                        io_1.println(chalk(templateObject_10 || (templateObject_10 = __makeTemplateObject(["\t({redBright --}) {white ", "}"], ["\\t({redBright --}) {white ", "}"])), objName));
                    }
                    else {
                        var oldGas = vDelta.gasUsed[0];
                        var newGas = vDelta.gasUsed[1];
                        if (newGas > oldGas) {
                            io_1.println(chalk(templateObject_11 || (templateObject_11 = __makeTemplateObject(["\t{white ", "}: ", " ", " ", ""], ["\\t{white ", "}: ", " ", " ", ""])), objName, chalk.blueBright(oldGas), WHITE_ARROW, chalk.redBright(newGas)));
                        }
                        else {
                            io_1.println(chalk(templateObject_12 || (templateObject_12 = __makeTemplateObject(["\t{white ", "}: ", " ", " ", ""], ["\\t{white ", "}: ", " ", " ", ""])), objName, chalk.blueBright(oldGas), WHITE_ARROW, chalk.greenBright(newGas)));
                        }
                    }
                }
            }
        }
    }
    io_1.println('\n');
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
var templateObject_1, templateObject_2, templateObject_3, templateObject_4, templateObject_5, templateObject_6, templateObject_7, templateObject_8, templateObject_9, templateObject_10, templateObject_11, templateObject_12;
