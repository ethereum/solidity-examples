"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
var chalk = require("chalk");
var io_1 = require("./io");
var TestLogger = /** @class */ (function () {
    function TestLogger() {
    }
    TestLogger.header = function (text) {
        io_1.println(chalk["cyanBright"](text));
    };
    TestLogger.info = function (text) {
        if (!TestLogger.__silent) {
            io_1.println(chalk["blueBright"](text));
        }
    };
    TestLogger.success = function (text) {
        if (!TestLogger.__silent) {
            io_1.println(chalk["greenBright"](text));
        }
    };
    TestLogger.moderate = function (text) {
        if (!TestLogger.__silent) {
            io_1.println(chalk["yellowBright"](text));
        }
    };
    TestLogger.fail = function (text) {
        io_1.println(chalk["redBright"](text));
    };
    TestLogger.setSilent = function (silent) {
        TestLogger.__silent = silent;
    };
    TestLogger.silent = function () {
        return TestLogger.__silent;
    };
    TestLogger.__silent = false;
    return TestLogger;
}());
exports.default = TestLogger;
