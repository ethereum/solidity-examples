#!/usr/bin/env node

import {GLOBAL_OPTIONS, OPTIONS} from "./commands/option";
import {COMMANDS} from "./commands/commands";
import Logger, {Level} from "../script/utils/logger";

const handleGlobalOptions = (opts: string[]) => {
    for (const opt of opts) {
        switch (opt) {
            case 'debug':
                Logger.setLevel(Level.Debug);
                break;
            default:
                // This should not happen or the parsing must have failed.
                throw new Error(`Internal error: global option not found: ${opt}`);
        }
    }
};

const printHelp = () => {
    COMMANDS['solstl'].printHelp();
};

const parseGlobalOption = (opt: string): string => GLOBAL_OPTIONS[opt] ? opt : '';

const parseOption = (opt: string): string => OPTIONS[opt] ? opt : '';

const parseShortFormGlobalOption = (sfo: string): string => {
    let opt = '';
    for (const o in GLOBAL_OPTIONS) {
        if (GLOBAL_OPTIONS[o].shortForm() === sfo) {
            opt = o;
            break;
        }
    }
    return opt;
};

const parseShortFormOption = (sfo: string): string => {
    let opt = '';
    for (const o in OPTIONS) {
        if (OPTIONS[o].shortForm() === sfo) {
            opt = o;
            break;
        }
    }
    return opt;
};

export const run = async (input: string[]) => {

    const optsfnd = {};
    const args = [];
    const globalOptions = [];
    const options = [];

    if (input.length === 0) {
        COMMANDS['solstl'].printHelp();
        return;
    }

    // Keep processing the first argument in the array.
    for (const ipt of input) {
        if (ipt.substr(0, 2) === '--') {
            // This is a long form option.
            const opt = ipt.substr(2);
            if (opt.length === 0) {
                throw new Error(`Empty flags not allowed.`);
            }
            const gOpt = parseGlobalOption(opt);
            if (gOpt !== '') {
                if (optsfnd[gOpt]) {
                    throw new Error(`Multiple instances of flag: --${opt}`);
                }
                globalOptions.push(gOpt);
                optsfnd[gOpt] = true;
            } else {
                const lOpt = parseOption(opt);
                if (lOpt === '') {
                    printHelp();
                    throw new Error(`Unknown flag: --${opt}`);
                }
                if (optsfnd[lOpt]) {
                    throw new Error(`Multiple instances of flag: --${opt}`);
                }
                options.push(lOpt);
                optsfnd[lOpt] = true;
            }
        } else if (ipt[0] === '-') {
            // This is a short-form option.
            if (ipt.length === 1) {
                throw new Error(`Empty flags not allowed.`);
            }
            if (ipt.length > 2) {
                throw new Error(`Short form options are single letter only: ${ipt}`);
            }
            const opt = ipt[1];
            const gOpt = parseShortFormGlobalOption(opt);
            if (gOpt !== '') {
                if (optsfnd[gOpt]) {
                    throw new Error(`Option found more then once: ${opt}`);
                }
                globalOptions.push(gOpt);
                optsfnd[gOpt] = true;
            } else {
                const lOpt = parseShortFormOption(opt);
                if (lOpt === '') {
                    printHelp();
                    throw new Error(`Unknown flag: ${ipt}`);
                }
                if (optsfnd[lOpt]) {
                    throw new Error(`Option found more then once: ${opt}`);
                }
                options.push(lOpt);
                optsfnd[lOpt] = true;
            }
        } else {
            // This is a command.
            args.push(ipt);
        }
    }

    // Handle all the global options (such as setting the log level).
    handleGlobalOptions(globalOptions);

    if (args.length === 0) {
        // No arguments
        await COMMANDS['solstl'].execute([], options);
    } else {
        const cmdName = args[0];
        const cmd = COMMANDS[cmdName];
        if (!cmd) {
            throw new Error(`Unknown command: ${cmdName}`);
        }
        await cmd.execute(args.slice(1), options);
    }
};

(async () => {
    try {
        await run(process.argv.slice(2));
    } catch (error) {
        Logger.error(error.message);
        if (Logger.level() === 'debug') {
            Logger.debug(error.stack);
        }
        process.exit(error);
    }
})();
