
import {librarySelectionData, prompt} from "./utils";
import {test} from "../../script/tests";
import Logger from "../../script/utils/logger";

export const testsMenu = async (): Promise<void> => {
    const selected = await prompt(librarySelectionData('tests'));
    let units = [];
    for (const tst of selected.tests) {
        if (tst[0] instanceof Array) {
            units = units.concat(tst);
        } else {
            units.push(tst);
        }
    }
    try {
        await test(units, false);
    } catch (err) {
        Logger.error(err.message);
    }
};
