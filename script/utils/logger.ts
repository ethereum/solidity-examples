import * as winston from 'winston';

const levels = {
    'silly': true,
    'debug': true,
    'verbose': true,
    'info': true,
    'warn': true,
    'error': true
};

const testConfig = {
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

export const newLogger = () => {
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

export const newTestLogger = () => {
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

const logger_ = newLogger();

const testLogger_ = newTestLogger();

export const consoleLevel = () => {
    return logger_.transports.console.level;
};

export const setConsoleLevel = (level: string, forceNotification: boolean = false) => {
    if (!levels[level]) {
        logger_.warn("Illegal logging level.");
        return;
    }
    if (forceNotification) {
        console.log('Setting logging level to: ' + level);
    } else {
        logger_.info('Setting logging level to: ' + level);
    }
    logger_.transports.console.level = level;
};

/**
 * Get the global logger instance.
 */
export const globalLogger = function () {
    return logger_;
};

/**
 * Get the global test logger instance.
 */
export const testLogger = function () {
    return testLogger_;
};

