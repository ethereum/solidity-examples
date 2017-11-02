import {EXIT_CHOICE, prompt, SEPARATOR} from "./utils";
import {testsMenu} from "./tests_prompt";
import {perfMenu} from "./perf_prompt";
import {logsMenu} from "./logs_prompt";
import {compileMenu} from "./compile_prompt";

export const mainPrompt = {
    type: 'list',
    name: 'main',
    message: 'Select an action to perform',
    choices: [
        {
            key: 'c',
            name: 'Compile contracts',
            value: 'compile'
        },
        {
            key: 't',
            name: 'Run tests',
            value: 'tests'
        },
        {
            key: 'p',
            name: 'Run perf',
            value: 'perf'
        },
        {
            key: 'l',
            name: 'Check logs',
            value: 'logs'
        }
    ].concat(SEPARATOR).concat(EXIT_CHOICE)
};

export const mainMenu = async (): Promise<boolean> => {
    const selected = await prompt(mainPrompt);
    switch (selected.main) {
        case "tests":                            // Options
            await testsMenu();
            break;
        case "perf":                             // Options
            await perfMenu();
            break;
        case "logs":                             // Options
            await logsMenu();
            break;
        case "compile":                          // Options
            await compileMenu();
            break;
        case "exit":                             // Navigation
            return true;
        default:
            return false;
    }
    return false;
};
