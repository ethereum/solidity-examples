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
var utils_1 = require("./utils");
var tests_prompt_1 = require("./tests_prompt");
var perf_prompt_1 = require("./perf_prompt");
var logs_prompt_1 = require("./logs_prompt");
var compile_prompt_1 = require("./compile_prompt");
exports.mainPrompt = {
    type: 'list',
    name: 'main',
    message: 'Select an action to perform',
    choices: [
        {
            key: 'c',
            name: 'Compile contracts',
            value: 'compile'
        },
        {
            key: 't',
            name: 'Run tests',
            value: 'tests'
        },
        {
            key: 'p',
            name: 'Run perf',
            value: 'perf'
        },
        {
            key: 'l',
            name: 'Check logs',
            value: 'logs'
        }
    ].concat(utils_1.SEPARATOR).concat(utils_1.EXIT_CHOICE)
};
exports.mainMenu = function () { return __awaiter(_this, void 0, void 0, function () {
    var selected, _a;
    return __generator(this, function (_b) {
        switch (_b.label) {
            case 0: return [4 /*yield*/, utils_1.prompt(exports.mainPrompt)];
            case 1:
                selected = _b.sent();
                _a = selected.main;
                switch (_a) {
                    case "tests": return [3 /*break*/, 2];
                    case "perf": return [3 /*break*/, 4];
                    case "logs": return [3 /*break*/, 6];
                    case "compile": return [3 /*break*/, 8];
                    case "exit": return [3 /*break*/, 10];
                }
                return [3 /*break*/, 11];
            case 2: // Options
            return [4 /*yield*/, tests_prompt_1.testsMenu()];
            case 3:
                _b.sent();
                return [3 /*break*/, 12];
            case 4: // Options
            return [4 /*yield*/, perf_prompt_1.perfMenu()];
            case 5:
                _b.sent();
                return [3 /*break*/, 12];
            case 6: // Options
            return [4 /*yield*/, logs_prompt_1.logsMenu()];
            case 7:
                _b.sent();
                return [3 /*break*/, 12];
            case 8: // Options
            return [4 /*yield*/, compile_prompt_1.compileMenu()];
            case 9:
                _b.sent();
                return [3 /*break*/, 12];
            case 10: // Navigation
            return [2 /*return*/, true];
            case 11: return [2 /*return*/, false];
            case 12: return [2 /*return*/, false];
        }
    });
}); };
