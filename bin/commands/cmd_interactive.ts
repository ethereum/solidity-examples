import {Command} from "./command";
import {mainMenu} from "../prompt/main_prompt";

export class InteractiveCommand extends Command {

    public async execute(args: string[], options: string[]) {
        if (!this.checkOptions(options)) {
            this.printHelp();
            return;
        }
        if (args.length !== 0) {
            this.printHelp();
            return;
        }
        // Stops linter from complaining.
        let terminate = false;
        while (!terminate) {
            terminate = await mainMenu();
        }
    }

    public name(): string {
        return 'interactive';
    }

    public description(): string {
        return 'Start an interactive session.';
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
