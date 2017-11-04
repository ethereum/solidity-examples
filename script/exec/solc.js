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
var path = require("path");
var child = require("child_process");
var constants_1 = require("../constants");
var logger_1 = require("../utils/logger");
var data_reader_1 = require("../utils/data_reader");
var exec = child.exec;
var execSync = child.execSync;
exports.compileTests = function (extended, optimize) { return __awaiter(_this, void 0, void 0, function () {
    var units, _i, units_1, test_1;
    return __generator(this, function (_a) {
        switch (_a.label) {
            case 0:
                units = data_reader_1.getAllTestFiles(extended);
                _i = 0, units_1 = units;
                _a.label = 1;
            case 1:
                if (!(_i < units_1.length)) return [3 /*break*/, 4];
                test_1 = units_1[_i];
                return [4 /*yield*/, exports.compileTest(test_1[0], test_1[1], optimize)];
            case 2:
                _a.sent();
                _a.label = 3;
            case 3:
                _i++;
                return [3 /*break*/, 1];
            case 4: return [2 /*return*/];
        }
    });
}); };
exports.compileTest = function (subdir, test, optimize) {
    if (optimize === void 0) { optimize = true; }
    return __awaiter(_this, void 0, void 0, function () {
        var filePath;
        return __generator(this, function (_a) {
            switch (_a.label) {
                case 0:
                    logger_1.default.info("Compiling unit: " + subdir + "/" + test);
                    filePath = path.join(constants_1.TEST_CONTRACT_PATH, subdir, test);
                    return [4 /*yield*/, exports.compile(filePath, constants_1.BIN_OUTPUT_PATH, optimize)];
                case 1:
                    _a.sent();
                    logger_1.default.info("Done");
                    return [2 /*return*/];
            }
        });
    });
};
exports.compilePerfs = function (extended, optimize) { return __awaiter(_this, void 0, void 0, function () {
    var units, _i, units_2, test_2;
    return __generator(this, function (_a) {
        switch (_a.label) {
            case 0:
                units = data_reader_1.getAllPerfFiles(extended);
                _i = 0, units_2 = units;
                _a.label = 1;
            case 1:
                if (!(_i < units_2.length)) return [3 /*break*/, 4];
                test_2 = units_2[_i];
                return [4 /*yield*/, exports.compilePerf(test_2[0], test_2[1], optimize)];
            case 2:
                _a.sent();
                _a.label = 3;
            case 3:
                _i++;
                return [3 /*break*/, 1];
            case 4: return [2 /*return*/];
        }
    });
}); };
exports.compilePerf = function (subdir, perf, optimize) {
    if (optimize === void 0) { optimize = true; }
    return __awaiter(_this, void 0, void 0, function () {
        var filePath;
        return __generator(this, function (_a) {
            switch (_a.label) {
                case 0:
                    logger_1.default.info("Compiling unit: " + subdir + "/" + perf);
                    filePath = path.join(constants_1.PERF_CONTRACT_PATH, subdir, perf);
                    return [4 /*yield*/, exports.compile(filePath, constants_1.BIN_OUTPUT_PATH, optimize)];
                case 1:
                    _a.sent();
                    logger_1.default.info("Done");
                    return [2 /*return*/];
            }
        });
    });
};
exports.compileUnits = function (optimize) {
    if (optimize === void 0) { optimize = true; }
    return __awaiter(_this, void 0, void 0, function () {
        var units, _i, units_3, test_3;
        return __generator(this, function (_a) {
            switch (_a.label) {
                case 0:
                    units = data_reader_1.getAllContractFiles();
                    _i = 0, units_3 = units;
                    _a.label = 1;
                case 1:
                    if (!(_i < units_3.length)) return [3 /*break*/, 4];
                    test_3 = units_3[_i];
                    return [4 /*yield*/, exports.compileUnit(test_3[0], test_3[1], optimize)];
                case 2:
                    _a.sent();
                    _a.label = 3;
                case 3:
                    _i++;
                    return [3 /*break*/, 1];
                case 4: return [2 /*return*/];
            }
        });
    });
};
exports.compileUnit = function (subdir, contract, optimize) {
    if (optimize === void 0) { optimize = true; }
    return __awaiter(_this, void 0, void 0, function () {
        var filePath;
        return __generator(this, function (_a) {
            switch (_a.label) {
                case 0:
                    logger_1.default.info("Compiling unit: " + subdir + "/" + contract);
                    filePath = path.join(constants_1.SRC_PATH, subdir, contract);
                    return [4 /*yield*/, exports.compile(filePath, constants_1.BIN_OUTPUT_PATH, optimize)];
                case 1:
                    _a.sent();
                    logger_1.default.info("Done");
                    return [2 /*return*/];
            }
        });
    });
};
exports.compile = function (filePath, outDir, optimize) { return __awaiter(_this, void 0, void 0, function () {
    return __generator(this, function (_a) {
        return [2 /*return*/, new Promise(function (resolve, reject) {
                var cmd = "solc .= --bin-runtime --hashes --metadata --overwrite " + (optimize ? "--optimize" : "") + " -o " + outDir + " " + filePath;
                exec(cmd, { cwd: constants_1.ROOT_PATH }, function (err, stdoud, stderr) {
                    var ret = stderr.toString();
                    logger_1.default.debug(ret);
                    if (err) {
                        reject(err);
                    }
                    else {
                        resolve();
                    }
                });
            })];
    });
}); };
function version() {
    var verStr = execSync('solc --version').toString();
    return verStr.substr(verStr.indexOf('\n')).substr(9).trim();
}
exports.version = version;
