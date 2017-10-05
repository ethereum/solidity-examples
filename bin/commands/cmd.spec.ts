import {COMMANDS} from "./commands";
import {OPTIONS} from "./option";

describe('commands, sanity check for command tree', () => {
    it('checks that commands are properly linked', () => {
        for (const cmdName in COMMANDS) {
            if (COMMANDS.hasOwnProperty(cmdName)) {
                const cmd = COMMANDS[cmdName];
                expect(cmd.name()).toBe(cmdName);
                expect(cmd.description()).not.toBe('');
                if (cmdName === 'solstl') {
                    expect(cmd.parent()).toBe('');
                } else {
                    expect(COMMANDS[cmd.parent()]).not.toBeUndefined();
                }
                for (const subCmd of cmd.subcommands()) {
                    expect(COMMANDS[subCmd]).not.toBeUndefined();
                }
                for (const optn of cmd.validOptions()) {
                    expect(OPTIONS[optn]).not.toBeUndefined();
                }
            }
        }
    });
});
