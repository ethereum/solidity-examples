import {Command} from "./command";
import {SolStlCommand} from "./cmd_solstl";
import {PerfCommand} from "./cmd_perf";
import {TestsCommand} from "./cmd_tests";
import {InteractiveCommand} from "./cmd_interactive";
import {CompileCommand} from "./cmd_compile";

export const COMMANDS: { [name: string]: Command } = {
    solstl: new SolStlCommand(),
    perf: new PerfCommand(),
    tests: new TestsCommand(),
    interactive: new InteractiveCommand(),
    compile: new CompileCommand()
};
