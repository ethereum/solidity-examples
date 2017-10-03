import * as fs from 'fs';
import * as path from 'path';
import {
    RESULTS_NAME_OPTIMIZED, RESULTS_NAME_UNOPTIMIZED, TEST_BIN, TEST_FUN_HASH, TEST_LOGS
} from "./constants";
import {createTimestampSubfolder, ensureAndClear, isSigInHashes, writeLog} from "./utils/io";
import {compileTest, version as solcVersion} from "./exec/solc";
import {run, version as evmVersion} from "./exec/evm";
import TestLogger from "./utils/test_logger";

export const test = async (tests: Array<[string, string]>, optAndUnopt: boolean) => {
    const solcV = solcVersion();
    const evmV = evmVersion();
    ensureAndClear(TEST_BIN);

    const ret = await compileAndRunTests(tests, true);

    const log = {
        solcVersion: solcV,
        evmVersion: evmV,
        results: ret.results
    };
    const logsPath = createTimestampSubfolder(TEST_LOGS);
    writeLog(log, logsPath, RESULTS_NAME_OPTIMIZED);

    let retU = null;
    if (optAndUnopt) {
        ensureAndClear(TEST_BIN);
        retU = await compileAndRunTests(tests, false);
        const logU = {
            solcVersion: solcV,
            evmVersion: evmV,
            results: retU.results
        };
        writeLog(logU, logsPath, RESULTS_NAME_UNOPTIMIZED);
    }

    if (!ret.success && (!optAndUnopt || retU.success)) {
        throw new Error("One or more tests failed.");
    }
};

export const compileAndRunTests = async (units: Array<[string, string]>, optimize: boolean) => {
    for (const unit of units) {
        const pckge = unit[0];
        const tst = unit[1];
        await compileTest(pckge, tst, optimize);
    }
    return runTests(optimize);
};

export const runTests = (optimize: boolean) => {
    const files = fs.readdirSync(TEST_BIN);
    const sigfiles = files.filter((file) => {
        const f = file.trim();
        return f.length > 4 && f.substr(0, 4) === 'Test' && f.split('.').pop() === 'signatures';
    });
    const results = {};

    let tests = 0;
    let failed = 0;

    TestLogger.header("Running tests...");

    for (const sigfile of sigfiles) {
        if (!isSigInHashes(TEST_BIN, sigfile, TEST_FUN_HASH)) {
            throw new Error(`No test function in signature file: ${sigfile}`);
        }
        const name = sigfile.substr(0, sigfile.length - 11);
        const binRuntimePath = path.join(TEST_BIN, name + ".bin-runtime");
        const result = parseData(run(binRuntimePath, TEST_FUN_HASH));

        const throws = /Throws/.test(name);

        let passed = true;
        tests++;
        if (throws && result) {
            passed = false;
        } else if (!throws && !result) {
            passed = false;
        }
        if (passed) {
            TestLogger.success(`${name}: PASSED`);
        } else {
            failed++;
            TestLogger.fail(`${name}: FAILED`);
        }
        results[name] = {passed};
    }
    TestLogger.header('');
    TestLogger.header(`Ran ${tests} tests.`);

    if (failed !== 0) {
        TestLogger.fail(`${failed} tests FAILED.`);
    } else {
        TestLogger.success(`All tests PASSED`);
    }
    return {
        success: failed === 0,
        results
    };
};

const parseData = (output: string): boolean => parseInt(output, 16) === 1;
