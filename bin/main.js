#!/usr/bin/env node
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
var option_1 = require("./commands/option");
var commands_1 = require("./commands/commands");
var logger_1 = require("../script/utils/logger");
var handleGlobalOptions = function (opts) {
    for (var _i = 0, opts_1 = opts; _i < opts_1.length; _i++) {
        var opt = opts_1[_i];
        switch (opt) {
            case 'debug':
                logger_1.default.setLevel(3 /* Debug */);
                break;
            default:
                // This should not happen or the parsing must have failed.
                throw new Error("Internal error: global option not found: " + opt);
        }
    }
};
var printHelp = function () {
    commands_1.COMMANDS['solstl'].printHelp();
};
var parseGlobalOption = function (opt) { return option_1.GLOBAL_OPTIONS[opt] ? opt : ''; };
var parseOption = function (opt) { return option_1.OPTIONS[opt] ? opt : ''; };
var parseShortFormGlobalOption = function (sfo) {
    var opt = '';
    for (var o in option_1.GLOBAL_OPTIONS) {
        if (option_1.GLOBAL_OPTIONS[o].shortForm() === sfo) {
            opt = o;
            break;
        }
    }
    return opt;
};
var parseShortFormOption = function (sfo) {
    var opt = '';
    for (var o in option_1.OPTIONS) {
        if (option_1.OPTIONS[o].shortForm() === sfo) {
            opt = o;
            break;
        }
    }
    return opt;
};
exports.run = function (input) { return __awaiter(_this, void 0, void 0, function () {
    var optsfnd, args, globalOptions, options, _i, input_1, ipt, opt, gOpt, lOpt, opt, gOpt, lOpt, cmdName, cmd;
    return __generator(this, function (_a) {
        switch (_a.label) {
            case 0:
                optsfnd = {};
                args = [];
                globalOptions = [];
                options = [];
                if (input.length === 0) {
                    commands_1.COMMANDS['solstl'].printHelp();
                    return [2 /*return*/];
                }
                // Keep processing the first argument in the array.
                for (_i = 0, input_1 = input; _i < input_1.length; _i++) {
                    ipt = input_1[_i];
                    if (ipt.substr(0, 2) === '--') {
                        opt = ipt.substr(2);
                        if (opt.length === 0) {
                            throw new Error("Empty flags not allowed.");
                        }
                        gOpt = parseGlobalOption(opt);
                        if (gOpt !== '') {
                            if (optsfnd[gOpt]) {
                                throw new Error("Multiple instances of flag: --" + opt);
                            }
                            globalOptions.push(gOpt);
                            optsfnd[gOpt] = true;
                        }
                        else {
                            lOpt = parseOption(opt);
                            if (lOpt === '') {
                                printHelp();
                                throw new Error("Unknown flag: --" + opt);
                            }
                            if (optsfnd[lOpt]) {
                                throw new Error("Multiple instances of flag: --" + opt);
                            }
                            options.push(lOpt);
                            optsfnd[lOpt] = true;
                        }
                    }
                    else if (ipt[0] === '-') {
                        // This is a short-form option.
                        if (ipt.length === 1) {
                            throw new Error("Empty flags not allowed.");
                        }
                        if (ipt.length > 2) {
                            throw new Error("Short form options are single letter only: " + ipt);
                        }
                        opt = ipt[1];
                        gOpt = parseShortFormGlobalOption(opt);
                        if (gOpt !== '') {
                            if (optsfnd[gOpt]) {
                                throw new Error("Option found more then once: " + opt);
                            }
                            globalOptions.push(gOpt);
                            optsfnd[gOpt] = true;
                        }
                        else {
                            lOpt = parseShortFormOption(opt);
                            if (lOpt === '') {
                                printHelp();
                                throw new Error("Unknown flag: " + ipt);
                            }
                            if (optsfnd[lOpt]) {
                                throw new Error("Option found more then once: " + opt);
                            }
                            options.push(lOpt);
                            optsfnd[lOpt] = true;
                        }
                    }
                    else {
                        // This is a command.
                        args.push(ipt);
                    }
                }
                // Handle all the global options (such as setting the log level).
                handleGlobalOptions(globalOptions);
                if (!(args.length === 0)) return [3 /*break*/, 2];
                // No arguments
                return [4 /*yield*/, commands_1.COMMANDS['solstl'].execute([], options)];
            case 1:
                // No arguments
                _a.sent();
                return [3 /*break*/, 4];
            case 2:
                cmdName = args[0];
                cmd = commands_1.COMMANDS[cmdName];
                if (!cmd) {
                    throw new Error("Unknown command: " + cmdName);
                }
                return [4 /*yield*/, cmd.execute(args.slice(1), options)];
            case 3:
                _a.sent();
                _a.label = 4;
            case 4: return [2 /*return*/];
        }
    });
}); };
(function () { return __awaiter(_this, void 0, void 0, function () {
    var error_1;
    return __generator(this, function (_a) {
        switch (_a.label) {
            case 0:
                _a.trys.push([0, 2, , 3]);
                return [4 /*yield*/, exports.run(process.argv.slice(2))];
            case 1:
                _a.sent();
                return [3 /*break*/, 3];
            case 2:
                error_1 = _a.sent();
                logger_1.default.error(error_1.message);
                if (logger_1.default.level() === 'debug') {
                    logger_1.default.debug(error_1.stack);
                }
                process.exit(error_1);
                return [3 /*break*/, 3];
            case 3: return [2 /*return*/];
        }
    });
}); })();
