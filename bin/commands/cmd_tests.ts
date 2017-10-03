import {Command} from "./command";
import {UNITS, UNITS_EXTENDED} from "../../script/constants";
import {test} from "../../script/tests";
import TestLogger from "../../script/utils/test_logger";

export class TestsCommand extends Command {

    public async execute(args: string[], options: string[]) {
        if (!this.checkOptions(options)) {
            this.printHelp();
            return;
        }
        if (args.length !== 0) {
            this.printHelp();
            return;
        }
        let optAndUnopt = false;
        let extended = false;
        for (const opt of options) {
            switch (opt) {
                case 'optAndUnopt':
                    optAndUnopt = true;
                    break;
                case 'extended':
                    extended = true;
                    break;
                case 'silentTests':
                    TestLogger.setSilent(true);
            }
        }
        const units = extended ? UNITS_EXTENDED : UNITS;
        await test(units, optAndUnopt);
    }

    public name(): string {
        return 'tests';
    }

    public description(): string {
        return 'Run the test suite.';
    }

    public validOptions(): string[] {
        return ['optAndUnopt', 'extended', 'silentTests'];
    }

    public parent(): string {
        return 'solstl';
    }

    public subcommands(): string[] {
        return [];
    }

    public arguments(): string[] {
        return [];
    }
}
