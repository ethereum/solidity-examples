import {librarySelectionData, prompt} from "./utils";
import {compile} from "../../script/compile";

export const compileMenu = async (): Promise<void> => {
    const selected = await prompt(librarySelectionData('compile'));
    if (selected.compile.length === 0) {
        return;
    }
    let units = [];
    for (const cmpl of selected.compile) {
        if (cmpl[0] instanceof Array) {
            units = units.concat(cmpl);
        } else {
            units.push(cmpl);
        }
    }
    await compile(units);
    await compileMenu();
};
