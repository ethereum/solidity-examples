import constants = require('../constants');
import path = require('path');
import child = require('child_process');
const execSync = child.execSync;

export function compileTest(subdir: string, test: string, optimize: boolean = true): string {
    const cmd = `solc .= --bin-runtime --hashes --overwrite ${optimize ? "--optimize" : ""} -o ${constants.TEST_BIN} ${path.join(constants.TEST_CONTRACT_PATH, subdir, test + '_tests.sol')}`;
    const ret = execSync(cmd, {cwd: constants.ROOT_PATH});
    return ret.toString();
}

export function compilePerf(subdir: string, perf: string, optimize: boolean = true): string {
    const cmd = `solc .= --bin-runtime --hashes --overwrite ${optimize ? "--optimize" : ""} -o ${constants.PERF_BIN} ${path.join(constants.PERF_CONTRACT_PATH, subdir, perf + '_perfs.sol')}`;
    const ret = execSync(cmd, {cwd: constants.ROOT_PATH});
    return ret.toString();
}

export function version(): string {
    return execSync('solc --version').toString();
}