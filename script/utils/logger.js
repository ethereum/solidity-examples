"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
var chalk = require("chalk");
var io_1 = require("./io");
var Logger = /** @class */ (function () {
    function Logger() {
    }
    Logger.error = function (text) {
        io_1.println(chalk['redBright']("[Error] " + text));
    };
    Logger.warn = function (text) {
        if (Logger.__level >= 1 /* Warn */) {
            io_1.println(chalk['yellowBright']("[Warning] " + text));
        }
    };
    Logger.info = function (text) {
        if (Logger.__level >= 2 /* Info */) {
            io_1.println(chalk['whiteBright']("[Info] " + text));
        }
    };
    Logger.debug = function (text) {
        if (Logger.__level === 3 /* Debug */) {
            io_1.println(chalk['blueBright']("[Debug] " + text));
        }
    };
    Logger.setLevel = function (level) {
        Logger.__level = level;
    };
    Logger.level = function () {
        switch (Logger.__level) {
            case 0 /* Error */:
                return 'error';
            case 1 /* Warn */:
                return 'warn';
            case 2 /* Info */:
                return 'info';
            case 3 /* Debug */:
                return 'debug';
        }
    };
    Logger.__level = 2 /* Info */;
    return Logger;
}());
exports.default = Logger;
