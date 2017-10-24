import * as chalk from 'chalk';
import {GLOBAL_OPTIONS, OPTIONS} from "./option";
import {COMMANDS} from "./commands";
import {println} from "../../script/utils/io";

export abstract class Command {

    public abstract async execute(args: string[], options: string[]);

    public abstract name(): string;

    public abstract description(): string;

    public abstract validOptions(): string[];

    public abstract parent(): string;

    public abstract subcommands(): string[];

    public abstract arguments(): string[];

    protected checkOptions(options: string[]) {
        // Check for the help flag first.
        for (const opt of options) {
            if (opt === 'help') {
                return false;
            }
        }
        for (const opt of options) {
            if (this.validOptions().indexOf(opt) < 0) {
                return false;
            }
        }
        return true;
    }

    public printHelp() {
        let command = this.name();
        let cmdStr = command;
        while (command !== 'solstl') {
            command = COMMANDS[this.parent()].name();
            cmdStr = this.parent() + ' ' + cmdStr;
        }
        const subcommands = this.subcommands();
        if (subcommands.length !== 0) {
            cmdStr += ` [SUBCOMMAND] [ARG]...`;
        } else {
            const args = this.arguments().join(' ').trim();
            if (args !== '') {
                cmdStr += ` ${args}`;
            }
        }
        const opts = this.validOptions();

        let help = '\n';
        help += `${chalk['bold']['white']('Command:')} ${chalk['magentaBright'](this.name())}\n\n`;
        help += `\t${this.description()}\n\n`;
        help += `${chalk['bold']['white']('Usage:')} ${cmdStr} [OPTION]...\n\n`;
        if (subcommands.length > 0) {
            help += `${chalk['bold']['white']('Subcommands:')}\n\n`;
            for (const subcommand of subcommands) {
                const scObj = COMMANDS[subcommand];
                const scStr = `${subcommand}                                                                        `.substr(0, 30) + scObj.description();
                help += `\t${scStr}\n`;
            }
            help += '\n';
        }
        if (opts.length > 0) {
            help += `${chalk['bold']['white']('Options:')}\n\n`;
            for (const opt of opts) {
                const optObj = OPTIONS[opt];
                const objStr = `--${optObj.name()}, -${optObj.shortForm()}                                          `.substr(0, 30) + optObj.info();
                help += `\t${objStr}\n`;
            }
            const helpStr = `--help, -H                                          `.substr(0, 30) + OPTIONS['help'].info();
            help += `\t${helpStr}\n`;
            help += '\n';
        }
        help += `${chalk['bold']['white']('Global Options:')}\n\n`;
        for (const opt in GLOBAL_OPTIONS) {
            if (GLOBAL_OPTIONS.hasOwnProperty(opt)) {
                const optObj = GLOBAL_OPTIONS[opt];
                const objStr = `--${optObj.name()}, -${optObj.shortForm()}                                          `.substr(0, 30) + optObj.info();
                help += `\t${objStr}\n`;
            }
        }
        println(help);
    }
}
