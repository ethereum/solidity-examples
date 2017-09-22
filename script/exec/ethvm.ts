import * as child from 'child_process';
import {PERF_FUN_HASH} from "../constants";
const execSync = child.execSync;

export const perf = (code: string): string => {
    const cmd = `ethvm --code ${code} --input ${PERF_FUN_HASH}`;
    const ret = execSync(cmd);
    return ret !== null ? ret.toString() : "";
};

export const version = (): string => {
    return execSync('ethvm --version').toString();
};