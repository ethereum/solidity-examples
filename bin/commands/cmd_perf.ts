import {Command} from "./command";
import {perf} from "../../script/perf";
import {latestPerfLog} from "../../script/utils/io";
import {printLatestDiff, printPerfLog} from "../../script/utils/logs";
import Logger from "../../script/utils/logger";
import {getAllPerfFiles} from "../../script/utils/data_reader";

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
        let silent = false;
        let diff = false;
        for (const opt of options) {
            switch (opt) {
                case 'optAndUnopt':
                    optAndUnopt = true;
                    break;
                case 'extended':
                    extended = true;
                    break;
                case 'silent':
                    silent = true;
                    break;
                case 'diff':
                    diff = true;
                    break;
            }
        }
        const units = getAllPerfFiles(extended);
        await perf(units, optAndUnopt);
        if (!silent) {
            printPerfLog(latestPerfLog());
        }
        if (diff) {
            if (!printLatestDiff()) {
               Logger.info("No previous perf logs exist.");
            }
        }
    }

    public name(): string {
        return 'perf';
    }

    public description(): string {
        return 'Run the perf suite.';
    }

    public validOptions(): string[] {
        return ['optAndUnopt', 'extended', 'silent', 'diff'];
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
