import * as fs from 'fs';
import * as path from 'path';
import {TEST_BIN, TEST_FUN_HASH, UNITS} from "./constants";
import {rmrf} from "./utils/files";
import {compileTest} from "./exec/solc";
import * as mkdirp from 'mkdirp';
import {test} from "./exec/evm";


export const testAll = (optAndUnopt: boolean): void => {
    rmrf(TEST_BIN);
    mkdirp.sync(TEST_BIN);

    compileAndRunTests(true);
    if (optAndUnopt) {
        rmrf(TEST_BIN);
        mkdirp.sync(TEST_BIN);
        compileAndRunTests(false);
    }
};

export const compileAndRunTests = (optimize: boolean) => {
    for (let i = 0; i < UNITS.length; i++) {
        const subDir = UNITS[i][0];
        const test = UNITS[i][1];
        compileTest(subDir, test, false);
    }
    runTests(optimize);
};

export const runTests = (optimize: boolean) => {

    const files = fs.readdirSync(TEST_BIN);
    const sigfiles = files.filter(function (file) {
        const f = file.trim();
        return f.length > 4 && f.substr(0, 4) === 'Test' && f.split('.').pop() === 'signatures';
    });
    for (let j = 0; j < sigfiles.length; j++) {
        const sigfile = sigfiles[j];
        const testName = sigfile.substr(0, sigfile.length - 11);
        const binRuntimePath = path.join(TEST_BIN, testName + ".bin-runtime");
        const hashesPath = path.join(TEST_BIN, sigfile);
        const hashes = fs.readFileSync(hashesPath).toString();

        const lines = hashes.split(/\r\n|\r|\n/);
        if (lines.length === 0) {
            throw new Error("No methods in: " + testName);
        }
        let testFound = false;
        for (let i = 0; i < lines.length; i++) {

            const line = lines[i].trim();
            if (line.length === 0) {
                continue;
            }
            const tokens = line.split(':');
            if (tokens.length !== 2) {
                throw new Error("No : separator in line: " + line);
            }
            const hash = tokens[0].trim();
            if (hash === TEST_FUN_HASH) {
                if (testFound) {
                    throw new Error("Repeated hash of test function in file: " + hashes);
                }
                testFound = true;
            }
        }
        if (!testFound) {
            throw new Error("Contract has no test: " + hashes);
        }

        const throws = /Throws/.test(testName);
        const result = parseData(test(binRuntimePath));

        if (throws && result) {
            throw new Error(`Failed: Expected test to throw: ${testName} (${optimize ? "optimized" : "unoptimized"})`);
        }

        if (!throws && !result) {
            throw new Error(`Failed: Expected test not to throw: ${testName} (${optimize ? "optimized" : "unoptimized"})`);
        }
    }
    console.log(`Successfully ran ${sigfiles.length} tests.`);
};


const parseData = (output: string): boolean => parseInt(output.trim(), 16) === 1;