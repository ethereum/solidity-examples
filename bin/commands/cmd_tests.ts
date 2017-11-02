import {Command} from "./command";
import {test} from "../../script/tests";
import {printTestLog} from "../../script/utils/logs";
import {latestTestLog} from "../../script/utils/io";
import {getAllTestFiles} from "../../script/utils/data_reader";

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
        let silent = false;
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
            }
        }
        const units = getAllTestFiles(extended);
        const result = await test(units, optAndUnopt);
        if (!silent) {
            printTestLog(latestTestLog());
        }
        if (!result) {
            throw new Error(`At least one test failed.`);
        }
    }

    public name(): string {
        return 'tests';
    }

    public description(): string {
        return 'Run the test suite.';
    }

    public validOptions(): string[] {
        return ['optAndUnopt', 'extended', 'silent'];
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
