import * as fs from 'fs';
import * as path from 'path';
import {
    RESULTS_NAME_OPTIMIZED, RESULTS_NAME_UNOPTIMIZED, TEST_BIN, TEST_FUN_HASH, TEST_LOGS, UNITS,
    UNITS_EXTENDED
} from "./constants";
import {createTimestampSubfolder, ensureAndClear, isSigInHashes, writeLog} from "./utils/files";
import {compileTest, version as solcVersion} from "./exec/solc";
import {run, version as evmVersion} from "./exec/evm";
import {newTestLogger} from "./utils/logger";

const testLogger = newTestLogger();

export const testAll = (extended: boolean, optAndUnopt: boolean): void => {
    const solcV = solcVersion();
    const evmV = evmVersion();
    ensureAndClear(TEST_BIN);

    const tests = extended ? UNITS_EXTENDED : UNITS;

    const ret = compileAndRunTests(tests, true);

    const log = {
        solcVersion: solcV,
        evmVersion: evmV,
        results: ret
    };
    const logsPath = createTimestampSubfolder(TEST_LOGS);
    writeLog(log, logsPath, RESULTS_NAME_OPTIMIZED);

    if (optAndUnopt) {
        ensureAndClear(TEST_BIN);
        const retU = compileAndRunTests(tests, false);
        const logU = {
            solcVersion: solcV,
            evmVersion: evmV,
            results: retU
        };
        writeLog(logU, logsPath, RESULTS_NAME_UNOPTIMIZED);
    }

    if(!checkAndPresent(ret)) {
        throw new Error("One or more tests failed.");
    }
};

export const compileAndRunTests = (units: Array<[string, string]>, optimize: boolean): Object => {
    for (let i = 0; i < units.length; i++) {
        const pckge = units[i][0];
        const test = units[i][1];
        compileTest(pckge, test, optimize);
    }
    return runTests(optimize);
};

export const runTests = (optimize: boolean): Object => {
    const files = fs.readdirSync(TEST_BIN);
    const sigfiles = files.filter(function (file) {
        const f = file.trim();
        return f.length > 4 && f.substr(0, 4) === 'Test' && f.split('.').pop() === 'signatures';
    });
    const results = {};

    for (let i = 0; i < sigfiles.length; i++) {
        const sigfile = sigfiles[i];
        if (!isSigInHashes(TEST_BIN, sigfile, TEST_FUN_HASH)) {
            throw new Error(`No test function in signature file: ${sigfile}`)
        }
        const name = sigfile.substr(0, sigfile.length - 11);
        const binRuntimePath = path.join(TEST_BIN, name + ".bin-runtime");
        const result = parseData(run(binRuntimePath, TEST_FUN_HASH));

        const throws = /Throws/.test(name);

        let passed = true;

        if (throws && result) {
            passed = false;
            console.error(`Failed: Expected test to throw: ${name} (${optimize ? "optimized" : "unoptimized"})`);
        } else if (!throws && !result) {
            passed = false;
            console.error(`Failed: Expected test not to throw: ${name} (${optimize ? "optimized" : "unoptimized"})`);
        }
        results[name] = {passed};
    }

    return results;
};

const checkAndPresent = (results: Object): boolean => {
    let tests = 0;
    let failed = 0;

    testLogger.header('');
    testLogger.header('Running tests... ');
    testLogger.header('');

    for(let name in results) {
        const res = results[name];
        tests++;
        if (res.passed) {
            testLogger.success(`${name}: PASSED`);
        } else {
            failed++;
            testLogger.fail(`${name}: FAILED`);
        }
    }

    testLogger.header('');
    testLogger.header(`Ran ${tests} tests.`);

    if (failed !== 0) {
        testLogger.fail(`${failed} tests FAILED.`);
        return false;
    } else {
        testLogger.success(`All tests PASSED`);
        return true;
    }
};


const parseData = (output: string): boolean => parseInt(output, 16) === 1;