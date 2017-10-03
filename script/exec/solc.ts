import * as path from 'path';
import * as child from 'child_process';
import {PERF_BIN, PERF_CONTRACT_PATH, ROOT_PATH, TEST_BIN, TEST_CONTRACT_PATH} from "../constants";
import Logger from "../utils/logger";

const exec = child.exec;
const execSync = child.execSync;

export const compileTest = async (subdir: string, test: string, optimize: boolean = true) => {
    Logger.info(`Compiling unit: ${subdir}/${test}`);
    const filePath = path.join(TEST_CONTRACT_PATH, subdir, test + '_tests.sol');
    await compile(filePath, TEST_BIN, optimize);
    Logger.info(`Done`);
};

export const compilePerf = async (subdir: string, perf: string, optimize: boolean = true) => {
    Logger.info(`Compiling unit: ${subdir}/${perf}`);
    const filePath = path.join(PERF_CONTRACT_PATH, subdir, perf + '_perfs.sol');
    await compile(filePath, PERF_BIN, optimize);
    Logger.info(`Done`);
};

export const compile = async (filePath: string, outDir: string, optimize: boolean) => {
    return new Promise((resolve, reject) => {
        const cmd = `solc .= --bin-runtime --hashes --overwrite ${optimize ? "--optimize" : ""} -o ${outDir} ${filePath}`;
        exec(cmd, {cwd: ROOT_PATH}, (err, stdoud, stderr) => {
            const ret = stderr.toString();
            Logger.debug(ret);
            if (err) {
                reject(err);
            } else {
                resolve();
            }
        });
    });
};

export function version(): string {
    const verStr = execSync('solc --version').toString();
    return verStr.substr(verStr.indexOf('\n')).trim();
}
