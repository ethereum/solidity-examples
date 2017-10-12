
import {librarySelectionData, prompt} from "./utils";
import {perf} from "../../script/perf";
import Logger from "../../script/utils/logger";
import {latestPerfLog} from "../../script/utils/io";
import {printPerfLog} from "../../script/utils/logs";

export const perfMenu = async (): Promise<void> => {
    const selected = await prompt(librarySelectionData('perf'));
    if (selected.perf.length === 0) {
        return;
    }
    let units = [];
    for (const prf of selected.perf) {
        if (prf[0] instanceof Array) {
            units = units.concat(prf);
        } else {
            units.push(prf);
        }
    }
    await perf(units, false);
    printPerfLog(latestPerfLog());
    await perfMenu();
};
