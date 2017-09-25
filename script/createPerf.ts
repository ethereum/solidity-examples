import * as fs from 'fs';
import * as path from 'path';
import {PERF_BIN, PERF_FUN_HASH, PERF_LOGS, RESULTS_NAME_OPTIMIZED, RESULTS_NAME_UNOPTIMIZED, UNITS} from "./constants";
import {
    createTimestampSubfolder, ensureAndClear, isSigInHashes, readLatest, readLog, writeLatest,
    writeLog
} from "./utils/files";
import {compilePerf, version as solcVersion} from "./exec/solc";
import {run, version as evmVersion} from './exec/evm';
import * as jsondiffpatch from 'jsondiffpatch';

export const perfAll = (optAndUnopt: boolean = false): void => {
    // Set up paths and check versions of the required tools.
    const solcV = solcVersion();
    const evmV = evmVersion();
    ensureAndClear(PERF_BIN);

    const ret = compileAndRunPerf(UNITS, true);

    const log = {
        solcVersion: solcV,
        evmVersion: evmV,
        results: ret
    };
    const logsPath = createTimestampSubfolder(PERF_LOGS);
    writeLog(log, logsPath, RESULTS_NAME_OPTIMIZED);

    // If unoptimized is enabled.
    if (optAndUnopt) {
        ensureAndClear(PERF_BIN);
        const retU = compileAndRunPerf(UNITS, false);
        const logU = {
            solcVersion: solcV,
            evmVersion: evmV,
            results: retU
        };
        writeLog(logU, logsPath, RESULTS_NAME_UNOPTIMIZED);
    }

    // Diffs
    const latest = readLatest(PERF_LOGS);
    if (latest !== '') {
        const latestResults = readLog(latest, RESULTS_NAME_OPTIMIZED);
        const diff = jsondiffpatch.diff(latestResults, log);
        if (diff) {
            const output = jsondiffpatch.formatters.console.format(diff);
            console.log("Changes since last run:");
            console.log(output);
        }
    }
    writeLatest(PERF_LOGS, logsPath);
};

export const compileAndRunPerf = (units: Array<[string, string]>, optimize: boolean): Object => {
    for (let i = 0; i < units.length; i++) {
        const subDir = units[i][0];
        const perf = units[i][1];
        compilePerf(subDir, perf, optimize);
    }
    return runPerf();
};

export const runPerf = (): Object => {
    const files = fs.readdirSync(PERF_BIN);
    const sigfiles = files.filter(function (file) {
        const f = file.trim();
        return f.length > 4 && f.substr(0, 4) === 'Perf' && f.split('.').pop() === 'signatures';
    });
    const results = {};

    for (let i = 0; i < sigfiles.length; i++) {
        const sigfile = sigfiles[i];
        if (!isSigInHashes(PERF_BIN, sigfile, PERF_FUN_HASH)) {
            throw new Error(`No perf function in signature file: ${sigfile}`)
        }
        const name = sigfile.substr(0, sigfile.length - 11);
        const binRuntimePath = path.join(PERF_BIN, name + ".bin-runtime");
        const result = run(binRuntimePath, PERF_FUN_HASH);
        const gasUsed = parseData(result);
        results[name] = {gasUsed};
    }
    return results;
};

const parseData = (output: string): number => parseInt(output, 16);