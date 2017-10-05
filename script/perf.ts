import * as fs from 'fs';
import * as path from 'path';
import {PERF_BIN, PERF_FUN_HASH, PERF_LOGS, RESULTS_NAME_OPTIMIZED, RESULTS_NAME_UNOPTIMIZED} from "./constants";
import {
    createTimestampSubfolder, ensureAndClear, isSigInHashes, readLatest, readLog, writeLatest,
    writeLog
} from "./utils/io";
import {compilePerf, version as solcVersion} from "./exec/solc";
import {run, version as evmVersion} from './exec/evm';
import * as jsondiffpatch from 'jsondiffpatch';
import TestLogger from "./utils/test_logger";

export const perf = async (units: Array<[string, string]>, optAndUnopt: boolean = false) => {
    // Set up paths and check versions of the required tools.
    const solcV = solcVersion();
    const evmV = evmVersion();
    ensureAndClear(PERF_BIN);

    const ret = await compileAndRunPerf(units, optAndUnopt);

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
        const retU = await compileAndRunPerf(units, false);
        const logU = {
            solcVersion: solcV,
            evmVersion: evmV,
            results: retU
        };
        writeLog(logU, logsPath, RESULTS_NAME_UNOPTIMIZED);
    }

    writeLatest(PERF_LOGS, logsPath);
};

export const compileAndRunPerf = async (units: Array<[string, string]>, optimize: boolean) => {
    for (const unit of units) {
        const subDir = unit[0];
        const prf = unit[1];
        await compilePerf(subDir, prf, optimize);
    }
    return runPerf();
};

export const runPerf = () => {
    const files = fs.readdirSync(PERF_BIN);
    const sigfiles = files.filter((file) => {
        const f = file.trim();
        return f.length > 4 && f.substr(0, 4) === 'Perf' && f.split('.').pop() === 'signatures';
    });
    const results = {};
    TestLogger.header("Running perf...");
    for (const sigfile of sigfiles) {
        if (!isSigInHashes(PERF_BIN, sigfile, PERF_FUN_HASH)) {
            throw new Error(`No perf function in signature file: ${sigfile}`);
        }
        const name = sigfile.substr(0, sigfile.length - 11);
        const binRuntimePath = path.join(PERF_BIN, name + ".bin-runtime");
        const result = run(binRuntimePath, PERF_FUN_HASH);
        const gasUsed = parseData(result);
        results[name] = {gasUsed};
    }
    TestLogger.header("Done");
    return results;
};

const parseData = (output: string): number => parseInt(output, 16);
