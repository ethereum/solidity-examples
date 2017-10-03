
import {librarySelectionData, prompt} from "./utils";
import {perf} from "../../script/perf";
import Logger from "../../script/utils/logger";

export const perfMenu = async (): Promise<void> => {
    const selected = await prompt(librarySelectionData('perf'));
    let units = [];
    for (const prf of selected.perf) {
        if (prf[0] instanceof Array) {
            units = units.concat(prf);
        } else {
            units.push(prf);
        }
    }
    try {
        await perf(units, false);
    } catch (err) {
        Logger.error(err.message);
    }
};
