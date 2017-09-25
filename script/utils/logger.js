"use strict";
exports.__esModule = true;
var winston = require("winston");
var levels = {
    'silly': true,
    'debug': true,
    'verbose': true,
    'info': true,
    'warn': true,
    'error': true
};
var testConfig = {
    levels: {
        header: 0,
        info: 1,
        success: 2,
        moderate: 3,
        fail: 4
    },
    colors: {
        header: 'magenta',
        info: 'cyan',
        success: 'green',
        moderate: 'yellow',
        fail: 'red'
    }
};
exports.newLogger = function () {
    return new (winston.Logger)({
        transports: [
            new (winston.transports.Console)({
                level: 'warn',
                label: 'Application'
            })
        ],
        label: "Application"
    });
};
exports.newTestLogger = function () {
    return new (winston.Logger)({
        transports: [
            new (winston.transports.Console)({
                name: 'default',
                colorize: 'all',
                level: 'fail',
                showLevel: false,
                label: ''
            })
        ],
        levels: testConfig.levels,
        colors: testConfig.colors
    });
};
var logger_ = exports.newLogger();
var testLogger_ = exports.newTestLogger();
exports.consoleLevel = function () {
    return logger_.transports.console.level;
};
exports.setConsoleLevel = function (level, forceNotification) {
    if (forceNotification === void 0) { forceNotification = false; }
    if (!levels[level]) {
        logger_.warn("Illegal logging level.");
        return;
    }
    if (forceNotification) {
        console.log('Setting logging level to: ' + level);
    }
    else {
        logger_.info('Setting logging level to: ' + level);
    }
    logger_.transports.console.level = level;
};
/**
 * Get the global logger instance.
 */
exports.globalLogger = function () {
    return logger_;
};
/**
 * Get the global test logger instance.
 */
exports.testLogger = function () {
    return testLogger_;
};
