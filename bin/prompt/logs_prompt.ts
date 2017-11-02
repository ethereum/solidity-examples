import {
    NAV_CHOICES, prompt, SEPARATOR} from "./utils";
import {printLatestDiff, printPerfLog, printTestLog} from "../../script/utils/logs";
import {latestPerfLog, latestTestLog} from "../../script/utils/io";
import Logger from "../../script/utils/logger";

export const logsPrompt = {
    type: 'list',
    name: 'logs',
    message: 'Select an action to perform',
    choices: [
        {
            key: 't',
            name: 'View latest test log',
            value: 'latest_test'
        },
        {
            key: 'p',
            name: 'View latest perf log',
            value: 'latest_perf'
        },
        {
            key: 'p',
            name: 'View latest perf diff',
            value: 'latest_perf_diff'
        }].concat(SEPARATOR).concat(NAV_CHOICES)
};

export const logsMenu = async (): Promise<void> => {
    const selected = await prompt(logsPrompt);
    switch (selected.logs) {
        case "latest_test":
            try {
                printTestLog(latestTestLog());
            } catch (err) {
                Logger.error(`Latest testlog could not be read: ${err.message}`);
            }
            break;
        case "latest_perf":
            try {
                printPerfLog(latestPerfLog());
            } catch (err) {
                Logger.error(`Latest testlog could not be read: ${err.message}`);
            }
            break;
        case "latest_perf_diff":
            if (!printLatestDiff()) {
                Logger.error(`Missing entries: Perf must have been run at least two times.`);
            }
            break;
        case "back":                             // Navigation
            return;
        case "exit":
            process.exit(0);
            break; // Make linter shut up.
        default:
            process.exit(1);
    }
    await logsMenu();
};
