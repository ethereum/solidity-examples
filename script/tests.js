"use strict";
var __awaiter = (this && this.__awaiter) || function (thisArg, _arguments, P, generator) {
    return new (P || (P = Promise))(function (resolve, reject) {
        function fulfilled(value) { try { step(generator.next(value)); } catch (e) { reject(e); } }
        function rejected(value) { try { step(generator["throw"](value)); } catch (e) { reject(e); } }
        function step(result) { result.done ? resolve(result.value) : new P(function (resolve) { resolve(result.value); }).then(fulfilled, rejected); }
        step((generator = generator.apply(thisArg, _arguments || [])).next());
    });
};
var __generator = (this && this.__generator) || function (thisArg, body) {
    var _ = { label: 0, sent: function() { if (t[0] & 1) throw t[1]; return t[1]; }, trys: [], ops: [] }, f, y, t, g;
    return g = { next: verb(0), "throw": verb(1), "return": verb(2) }, typeof Symbol === "function" && (g[Symbol.iterator] = function() { return this; }), g;
    function verb(n) { return function (v) { return step([n, v]); }; }
    function step(op) {
        if (f) throw new TypeError("Generator is already executing.");
        while (_) try {
            if (f = 1, y && (t = y[op[0] & 2 ? "return" : op[0] ? "throw" : "next"]) && !(t = t.call(y, op[1])).done) return t;
            if (y = 0, t) op = [0, t.value];
            switch (op[0]) {
                case 0: case 1: t = op; break;
                case 4: _.label++; return { value: op[1], done: false };
                case 5: _.label++; y = op[1]; op = [0]; continue;
                case 7: op = _.ops.pop(); _.trys.pop(); continue;
                default:
                    if (!(t = _.trys, t = t.length > 0 && t[t.length - 1]) && (op[0] === 6 || op[0] === 2)) { _ = 0; continue; }
                    if (op[0] === 3 && (!t || (op[1] > t[0] && op[1] < t[3]))) { _.label = op[1]; break; }
                    if (op[0] === 6 && _.label < t[1]) { _.label = t[1]; t = op; break; }
                    if (t && _.label < t[2]) { _.label = t[2]; _.ops.push(op); break; }
                    if (t[2]) _.ops.pop();
                    _.trys.pop(); continue;
            }
            op = body.call(thisArg, _);
        } catch (e) { op = [6, e]; y = 0; } finally { f = t = 0; }
        if (op[0] & 5) throw op[1]; return { value: op[0] ? op[1] : void 0, done: true };
    }
};
var _this = this;
Object.defineProperty(exports, "__esModule", { value: true });
var fs = require("fs");
var path = require("path");
var constants_1 = require("./constants");
var io_1 = require("./utils/io");
var solc_1 = require("./exec/solc");
var evm_1 = require("./exec/evm");
var test_logger_1 = require("./utils/test_logger");
exports.test = function (tests, optAndUnopt) { return __awaiter(_this, void 0, void 0, function () {
    var solcV, evmV, ret, log, logsPath, retU, logU;
    return __generator(this, function (_a) {
        switch (_a.label) {
            case 0:
                solcV = solc_1.version();
                evmV = evm_1.version();
                io_1.ensureAndClear(constants_1.BIN_OUTPUT_PATH);
                return [4 /*yield*/, exports.compileAndRunTests(tests, true)];
            case 1:
                ret = _a.sent();
                log = {
                    solcVersion: solcV,
                    evmVersion: evmV,
                    results: ret.results
                };
                logsPath = io_1.createTimestampSubfolder(constants_1.TEST_LOGS_PATH);
                io_1.writeLog(log, logsPath, constants_1.RESULTS_NAME_OPTIMIZED);
                retU = null;
                if (!optAndUnopt) return [3 /*break*/, 3];
                io_1.ensureAndClear(constants_1.BIN_OUTPUT_PATH);
                return [4 /*yield*/, exports.compileAndRunTests(tests, false)];
            case 2:
                retU = _a.sent();
                logU = {
                    solcVersion: solcV,
                    evmVersion: evmV,
                    results: retU.results
                };
                io_1.writeLog(logU, logsPath, constants_1.RESULTS_NAME_UNOPTIMIZED);
                _a.label = 3;
            case 3:
                io_1.writeLatest(constants_1.TEST_LOGS_PATH, logsPath);
                return [2 /*return*/, ret.success && (!optAndUnopt || retU.success)];
        }
    });
}); };
exports.compileAndRunTests = function (units, optimize) { return __awaiter(_this, void 0, void 0, function () {
    var _i, units_1, unit, pckge, tst;
    return __generator(this, function (_a) {
        switch (_a.label) {
            case 0:
                _i = 0, units_1 = units;
                _a.label = 1;
            case 1:
                if (!(_i < units_1.length)) return [3 /*break*/, 4];
                unit = units_1[_i];
                pckge = unit[0];
                tst = unit[1];
                if (tst === '') {
                    return [3 /*break*/, 3];
                }
                return [4 /*yield*/, solc_1.compileTest(pckge, tst, optimize)];
            case 2:
                _a.sent();
                _a.label = 3;
            case 3:
                _i++;
                return [3 /*break*/, 1];
            case 4: return [2 /*return*/, exports.runTests()];
        }
    });
}); };
exports.runTests = function () {
    var files = fs.readdirSync(constants_1.BIN_OUTPUT_PATH);
    var sigfiles = files.filter(function (file) {
        var f = file.trim();
        return f.length > 4 && f.substr(0, 4) === 'Test' && f.split('.').pop() === 'signatures';
    });
    var results = {};
    var tests = 0;
    var failed = 0;
    test_logger_1.default.header('Running tests...');
    for (var _i = 0, sigfiles_1 = sigfiles; _i < sigfiles_1.length; _i++) {
        var sigfile = sigfiles_1[_i];
        if (!io_1.isSigInHashes(constants_1.BIN_OUTPUT_PATH, sigfile, constants_1.TEST_FUN_HASH)) {
            throw new Error("No test function in signature file: " + sigfile);
        }
        var name = sigfile.substr(0, sigfile.length - 11);
        var binRuntimePath = path.join(constants_1.BIN_OUTPUT_PATH, name + ".bin-runtime");
        var result = parseData(evm_1.run(binRuntimePath, constants_1.TEST_FUN_HASH));
        var throws = /Throws/.test(name);
        var passed = true;
        tests++;
        if (throws && result) {
            failed++;
            passed = false;
        }
        else if (!throws && !result) {
            failed++;
            passed = false;
        }
        results[name] = { passed: passed };
    }
    test_logger_1.default.header("Done");
    return {
        success: failed === 0,
        results: results
    };
};
var parseData = function (output) { return parseInt(output, 16) === 1; };
