import {ensureAndClear} from "./utils/io";
import {BIN_OUTPUT_PATH} from "./constants";
import {compileUnit} from "./exec/solc";
import {getAllContractFiles} from "./utils/data_reader";

export const compileAll = async (): Promise<void> => {
    ensureAndClear(BIN_OUTPUT_PATH);
    const units = getAllContractFiles();
    for (const unit of units) {
        await compileUnit(unit[0], unit[1], true);
    }
};

export const compile = async (units: Array<[string, string]>): Promise<void> => {
    ensureAndClear(BIN_OUTPUT_PATH);
    for (const unit of units) {
        await compileUnit(unit[0], unit[1], true);
    }
};
