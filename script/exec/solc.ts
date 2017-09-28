import * as path from 'path';
import * as child from 'child_process';
import {PERF_BIN, PERF_CONTRACT_PATH, ROOT_PATH, TEST_BIN, TEST_CONTRACT_PATH} from "../constants";
const execSync = child.execSync;

export function compileTest(subdir: string, test: string, optimize: boolean = true): string {
    const cmd = `solc .= --bin-runtime --hashes --overwrite ${optimize ? "--optimize" : ""} -o ${TEST_BIN} ${path.join(TEST_CONTRACT_PATH, subdir, test + '_tests.sol')}`;
    const ret = execSync(cmd, {cwd: ROOT_PATH});
    return ret.toString();
}

export function compilePerf(subdir: string, perf: string, optimize: boolean = true): string {
    const cmd = `solc .= --bin-runtime --hashes --overwrite ${optimize ? "--optimize" : ""} -o ${PERF_BIN} ${path.join(PERF_CONTRACT_PATH, subdir, perf + '_perfs.sol')}`;
    const ret = execSync(cmd, {cwd: ROOT_PATH});
    return ret.toString();
}

export function compileRuntime(file: string, optimize: boolean = true): string {
    const cmd = `solc .= --bin-runtime ${optimize ? "--optimize" : ""} ${file}`;
    const ret = execSync(cmd, {cwd: ROOT_PATH});
    return ret.toString();
}

export function version(): string {
    const verStr = execSync('solc --version').toString();
    return verStr.substr(verStr.indexOf('\n')).trim();
}