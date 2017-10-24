import * as path from 'path';
import * as child from 'child_process';
import {
    BIN_OUTPUT, PERF_CONTRACT_PATH, ROOT_PATH, SRC_PATH, TEST_CONTRACT_PATH, UNITS, UNITS_EXTENDED
} from "../constants";
import Logger from "../utils/logger";

const exec = child.exec;
const execSync = child.execSync;

export const compileTests = async (extended: boolean, optimize: boolean) => {
    const units = extended ? UNITS_EXTENDED : UNITS;
    for (const test of units) {
        await compileTest(test[0], test[1], optimize);
    }
};

export const compileTest = async (subdir: string, test: string, optimize: boolean = true) => {
    Logger.info(`Compiling unit: ${subdir}/${test}`);
    const filePath = path.join(TEST_CONTRACT_PATH, subdir, test + '_tests.sol');
    await compile(filePath, BIN_OUTPUT, optimize);
    Logger.info(`Done`);
};

export const compilePerfs = async (extended: boolean, optimize: boolean) => {
    const units = extended ? UNITS_EXTENDED : UNITS;
    for (const test of units) {
        await compilePerf(test[0], test[1], optimize);
    }
};

export const compilePerf = async (subdir: string, perf: string, optimize: boolean = true) => {
    Logger.info(`Compiling unit: ${subdir}/${perf}`);
    const filePath = path.join(PERF_CONTRACT_PATH, subdir, perf + '_perfs.sol');
    await compile(filePath, BIN_OUTPUT, optimize);
    Logger.info(`Done`);
};

export const compileUnits = async (extended: boolean, optimize: boolean) => {
    const units = extended ? UNITS_EXTENDED : UNITS;
    for (const test of units) {
        await compileUnit(test[0], test[1], optimize);
    }
};

export const compileUnit = async (subdir: string, contract: string, optimize: boolean = true) => {
    Logger.info(`Compiling unit: ${subdir}/${contract}`);
    const filePath = path.join(SRC_PATH, subdir, contract + '.sol');
    await compile(filePath, BIN_OUTPUT, optimize);
    Logger.info(`Done`);
};

export const compile = async (filePath: string, outDir: string, optimize: boolean) => {
    return new Promise((resolve, reject) => {
        const cmd = `solc .= --bin-runtime --hashes --metadata --devdoc --overwrite ${optimize ? "--optimize" : ""} -o ${outDir} ${filePath}`;
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
    return verStr.substr(verStr.indexOf('\n')).substr(9).trim();
}
