import {Command} from "./command";
import {compileTests} from "../../script/exec/solc";
import {compileAll} from "../../script/compile";

export class CompileCommand extends Command {

    public async execute(args: string[], options: string[]) {
        if (!this.checkOptions(options)) {
            this.printHelp();
            return;
        }
        if (args.length !== 0) {
            this.printHelp();
            return;
        }
        let extended = false;
        for (const opt of options) {
            switch (opt) {
                case 'extended':
                    extended = true;
                    break;
            }
        }
        await compileAll(extended);
    }

    public name(): string {
        return 'compile';
    }

    public description(): string {
        return 'Compile all contracts.';
    }

    public validOptions(): string[] {
        return ['extended'];
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
