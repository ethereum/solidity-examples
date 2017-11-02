import {Command} from "./command";
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
        await compileAll();
    }

    public name(): string {
        return 'compile';
    }

    public description(): string {
        return 'Compile all contracts.';
    }

    public validOptions(): string[] {
        return [];
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
