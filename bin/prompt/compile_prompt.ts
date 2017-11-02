import {prompt} from "./utils";
import {compile} from "../../script/compile";
import {getAllContractFiles} from "../../script/utils/data_reader";

export const contractSelectionData = () => {
    const choices = getAllContractFiles().map((file) => {
        return {
            name: `${file[0]}/${file[1]}`,
            value: file
        };
    });
    return {
        type: 'checkbox',
        message: 'Select contracts (select none and press <enter> to go back)',
        name: "compile",
        choices
    };
};

export const compileMenu = async (): Promise<void> => {
    const selected = await prompt(contractSelectionData());
    if (selected.compile.length === 0) {
        return;
    }
    await compile(selected.compile);
};
