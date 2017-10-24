import {Command} from "./command";
import * as fs from 'fs';
import * as path from 'path';

const packageFile = fs.readFileSync(path.join(__dirname, '..', '..', 'package.json')).toString();
const packageObj = JSON.parse(packageFile);
const version = packageObj.version;

export class SolStlCommand extends Command {

    public async execute(args: string[], options: string[]) {
        if (!this.checkOptions(options)) {
           this.printHelp();
           return;
        }

        if (args.length !== 0) {
            this.printHelp();
            return;
        }
        if (options[0] === 'version') {
            console.log('Solidity Standard Library, version: ' + version);
        }
    }

    public name(): string {
        return 'solstl';
    }

    public description(): string {
        return 'Root command.';
    }

    public validOptions(): string[] {
        return ['version'];
    }

    public parent(): string {
        return '';
    }

    public subcommands(): string[] {
        return ['perf', 'tests', 'interactive', 'compile'];
    }

    public arguments(): string[] {
        return [];
    }
}
