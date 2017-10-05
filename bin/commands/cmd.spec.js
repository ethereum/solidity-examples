"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
var commands_1 = require("./commands");
var option_1 = require("./option");
describe('commands, sanity check for command tree', function () {
    it('checks that commands are properly linked', function () {
        for (var cmdName in commands_1.COMMANDS) {
            if (commands_1.COMMANDS.hasOwnProperty(cmdName)) {
                var cmd = commands_1.COMMANDS[cmdName];
                expect(cmd.name()).toBe(cmdName);
                expect(cmd.description()).not.toBe('');
                if (cmdName === 'solstl') {
                    expect(cmd.parent()).toBe('');
                }
                else {
                    expect(commands_1.COMMANDS[cmd.parent()]).not.toBeUndefined();
                }
                for (var _i = 0, _a = cmd.subcommands(); _i < _a.length; _i++) {
                    var subCmd = _a[_i];
                    expect(commands_1.COMMANDS[subCmd]).not.toBeUndefined();
                }
                for (var _b = 0, _c = cmd.validOptions(); _b < _c.length; _b++) {
                    var optn = _c[_b];
                    expect(option_1.OPTIONS[optn]).not.toBeUndefined();
                }
            }
        }
    });
});
