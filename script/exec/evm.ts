import * as child from 'child_process';
import {PERF_FUN_HASH, TEST_FUN_HASH} from "../constants";
const execSync = child.execSync;

export const perf = (file: string): string => {
    const cmd = `evm --codefile ${file} --input ${PERF_FUN_HASH} run`;
    const ret = execSync(cmd);
    return ret !== null ? ret.toString() : "";
};

export const test = (file: string): string => {
    const cmd = `evm --codefile ${file} --input ${TEST_FUN_HASH} run`;
    const ret = execSync(cmd);
    return ret !== null ? ret.toString() : "";
};

export const version = (): string => {
    return execSync('evm --version').toString();
};