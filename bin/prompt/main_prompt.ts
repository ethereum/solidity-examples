import {EXIT_CHOICE, prompt, SEPARATOR} from "./utils";
import {docsMenu} from "./docs_prompt";
import {testsMenu} from "./tests_prompt";
import {perfMenu} from "./perf_prompt";

export const mainPrompt = {
    type: 'list',
    name: 'main',
    message: 'Select an action to perform',
    choices: [
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
        },
        {
            key: 'd',
            name: 'View docs',
            value: 'docs'
        }
    ].concat(SEPARATOR).concat(EXIT_CHOICE)
};

export const mainMenu = async (): Promise<boolean> => {
    const selected = await prompt(mainPrompt);
    switch (selected.main) {
        case "tests":                             // Options
            await testsMenu();
            break;
        case "perf":                             // Options
            await perfMenu();
            break;
        case "logs":                             // Options
            // await logsMenu();
            break;
        case "docs":                             // Options
            await docsMenu();
            break;
        case "exit":                             // Navigation
            return true;
        default:
            return false;
    }
    return false;
};
