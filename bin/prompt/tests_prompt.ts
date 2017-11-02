import {prompt} from "./utils";
import {test} from "../../script/tests";
import {printTestLog} from "../../script/utils/logs";
import {latestTestLog} from "../../script/utils/io";
import {getAllTestFiles} from "../../script/utils/data_reader";

export const testSelectionData = () => {
    const choices = getAllTestFiles().map((file) => {
        return {
            name: `${file[0]}/${file[1]}`,
            value: file
        };
    });
    return {
        type: 'checkbox',
        message: 'Select contracts (select none and press <enter> to go back)',
        name: "tests",
        choices
    };
};

export const testsMenu = async (): Promise<void> => {
    const selected = await prompt(testSelectionData());
    if (selected.tests.length === 0) {
        return;
    }
    await test(selected.tests, false);
    printTestLog(latestTestLog());
    await testsMenu();
};
