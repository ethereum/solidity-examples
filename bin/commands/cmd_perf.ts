import {Command} from "./command";
import {perf} from "../../script/perf";
import {UNITS, UNITS_EXTENDED} from "../../script/constants";

export class PerfCommand extends Command {

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
            }
        }
        const units = extended ? UNITS_EXTENDED : UNITS;
        await perf(units, optAndUnopt);
    }

    public name(): string {
        return 'perf';
    }

    public description(): string {
        return 'Run the perf suite.';
    }

    public validOptions(): string[] {
        return ['optAndUnopt', 'extended'];
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
