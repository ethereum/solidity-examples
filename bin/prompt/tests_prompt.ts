
import {librarySelectionData, prompt} from "./utils";
import {test} from "../../script/tests";
import Logger from "../../script/utils/logger";
import {printTestLog} from "../../script/utils/logs";
import {latestTestLog} from "../../script/utils/io";

export const testsMenu = async (): Promise<void> => {
    const selected = await prompt(librarySelectionData('tests'));
    if (selected.tests.length === 0) {
        return;
    }
    let units = [];
    for (const tst of selected.tests) {
        if (tst[0] instanceof Array) {
            units = units.concat(tst);
        } else {
            units.push(tst);
        }
    }
    await test(units, false);
    printTestLog(latestTestLog());
    await testsMenu();
};
