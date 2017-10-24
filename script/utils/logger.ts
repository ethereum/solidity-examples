import * as chalk from 'chalk';
import {println} from "./io";

export const enum Level {
    Error,
    Warn,
    Info,
    Debug
}

export default class Logger {

    private static __level: Level = Level.Info;

    public static error(text: string) {
        println(chalk['redBright'](`[Error] ${text}`));
    }

    public static warn(text: string) {
        if (Logger.__level >= Level.Warn) {
            println(chalk['yellowBright'](`[Warning] ${text}`));
        }
    }

    public static info(text: string) {
        if (Logger.__level >= Level.Info) {
            println(chalk['whiteBright'](`[Info] ${text}`));
        }
    }

    public static debug(text: string) {
        if (Logger.__level === Level.Debug) {
            println(chalk['blueBright'](`[Debug] ${text}`));
        }
    }

    public static setLevel(level: Level) {
        Logger.__level = level;
    }

    public static level(): string {
        switch (Logger.__level) {
            case Level.Error:
                return 'error';
            case Level.Warn:
                return 'warn';
            case Level.Info:
                return 'info';
            case Level.Debug:
                return 'debug';
        }
    }
}
