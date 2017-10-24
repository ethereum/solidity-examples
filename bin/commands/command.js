"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
var chalk = require("chalk");
var option_1 = require("./option");
var commands_1 = require("./commands");
var io_1 = require("../../script/utils/io");
var Command = /** @class */ (function () {
    function Command() {
    }
    Command.prototype.checkOptions = function (options) {
        // Check for the help flag first.
        for (var _i = 0, options_1 = options; _i < options_1.length; _i++) {
            var opt = options_1[_i];
            if (opt === 'help') {
                return false;
            }
        }
        for (var _a = 0, options_2 = options; _a < options_2.length; _a++) {
            var opt = options_2[_a];
            if (this.validOptions().indexOf(opt) < 0) {
                return false;
            }
        }
        return true;
    };
    Command.prototype.printHelp = function () {
        var command = this.name();
        var cmdStr = command;
        while (command !== 'solstl') {
            command = commands_1.COMMANDS[this.parent()].name();
            cmdStr = this.parent() + ' ' + cmdStr;
        }
        var subcommands = this.subcommands();
        if (subcommands.length !== 0) {
            cmdStr += " [SUBCOMMAND] [ARG]...";
        }
        else {
            var args = this.arguments().join(' ').trim();
            if (args !== '') {
                cmdStr += " " + args;
            }
        }
        var opts = this.validOptions();
        var help = '\n';
        help += chalk['bold']['white']('Command:') + " " + chalk['magentaBright'](this.name()) + "\n\n";
        help += "\t" + this.description() + "\n\n";
        help += chalk['bold']['white']('Usage:') + " " + cmdStr + " [OPTION]...\n\n";
        if (subcommands.length > 0) {
            help += chalk['bold']['white']('Subcommands:') + "\n\n";
            for (var _i = 0, subcommands_1 = subcommands; _i < subcommands_1.length; _i++) {
                var subcommand = subcommands_1[_i];
                var scObj = commands_1.COMMANDS[subcommand];
                var scStr = (subcommand + "                                                                        ").substr(0, 30) + scObj.description();
                help += "\t" + scStr + "\n";
            }
            help += '\n';
        }
        if (opts.length > 0) {
            help += chalk['bold']['white']('Options:') + "\n\n";
            for (var _a = 0, opts_1 = opts; _a < opts_1.length; _a++) {
                var opt = opts_1[_a];
                var optObj = option_1.OPTIONS[opt];
                var objStr = ("--" + optObj.name() + ", -" + optObj.shortForm() + "                                          ").substr(0, 30) + optObj.info();
                help += "\t" + objStr + "\n";
            }
            var helpStr = "--help, -H                                          ".substr(0, 30) + option_1.OPTIONS['help'].info();
            help += "\t" + helpStr + "\n";
            help += '\n';
        }
        help += chalk['bold']['white']('Global Options:') + "\n\n";
        for (var opt in option_1.GLOBAL_OPTIONS) {
            if (option_1.GLOBAL_OPTIONS.hasOwnProperty(opt)) {
                var optObj = option_1.GLOBAL_OPTIONS[opt];
                var objStr = ("--" + optObj.name() + ", -" + optObj.shortForm() + "                                          ").substr(0, 30) + optObj.info();
                help += "\t" + objStr + "\n";
            }
        }
        io_1.println(help);
    };
    return Command;
}());
exports.Command = Command;
