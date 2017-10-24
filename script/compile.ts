import {ensureAndClear} from "./utils/io";
import {BIN_OUTPUT, UNITS, UNITS_EXTENDED} from "./constants";
import {compileUnit} from "./exec/solc";

export const compileAll = async (extended: boolean = false): Promise<void> => {
    ensureAndClear(BIN_OUTPUT);
    const units = extended ? UNITS_EXTENDED : UNITS;
    for (const unit of units) {
        if (unit[1] === '') {
            continue;
        }
        await compileUnit(unit[0], unit[1], true);
    }
};

export const compile = async (units: Array<[string, string, string]>): Promise<void> => {
    ensureAndClear(BIN_OUTPUT);
    for (const unit of units) {
        if (unit[1] === '') {
            continue;
        }
        await compileUnit(unit[0], unit[1], true);
    }
};
