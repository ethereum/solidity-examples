import {prompt} from "./utils";
import {perf} from "../../script/perf";
import {latestPerfLog} from "../../script/utils/io";
import {printPerfLog} from "../../script/utils/logs";
import {getAllPerfFiles} from "../../script/utils/data_reader";

export const perfSelectionData = () => {
    const choices = getAllPerfFiles().map((file) => {
        return {
            name: `${file[0]}/${file[1]}`,
            value: file
        };
    });
    return {
        type: 'checkbox',
        message: 'Select contracts (select none and press <enter> to go back)',
        name: "perf",
        choices
    };
};

export const perfMenu = async (): Promise<void> => {
    const selected = await prompt(perfSelectionData());
    if (selected.perf.length === 0) {
        return;
    }
    await perf(selected.perf, false);
    printPerfLog(latestPerfLog());
    await perfMenu();
};
