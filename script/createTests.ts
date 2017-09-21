import * as fs from 'fs';
import * as path from 'path';
import {FILLERS_PATH, TEST_BIN, TEST_FUN_HASH, UNITS, TESTS_PATH} from "./constants";
import {rmrf} from "./utils/files";
import {testeth} from "./exec/testeth";
import {compileTest} from "./exec/solc";
import {generateDefaultTestFiller} from '../script/utils/filler';
import * as mkdirp from 'mkdirp';

const generators = {};

export const registerTests = () => {
    for (let i = 0; i < UNITS.length; i++) {
        const gens = UNITS[i][2];
        const tests = gens();
        for(let test in tests) {
            if(generators[test]) {
                throw new Error(`Multiple generators for: `);
            }
            generators[test] = tests[test];
        }
    }
};

export const testAll = (optAndUnopt: boolean): void => {
    registerTests();
    rmrf(TESTS_PATH);
    rmrf(FILLERS_PATH);
    mkdirp.sync(FILLERS_PATH);

    rmrf(TEST_BIN);
    mkdirp.sync(TEST_BIN);
    compileAndGenerateFillers(true);
    if (optAndUnopt) {
        rmrf(TEST_BIN);
        fs.mkdirSync(TEST_BIN);
        compileAndGenerateFillers(false);
    }
    testeth();
};

export const compileAndGenerateFillers = (optimize: boolean) => {
    for (let i = 0; i < UNITS.length; i++) {
        const subDir = UNITS[i][0];
        const test = UNITS[i][1];
        compileTest(subDir, test, false);
    }
    generateFillers(optimize);
};

export const generateFillers = (optimize: boolean) => {

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
        const binRuntime = fs.readFileSync(binRuntimePath).toString();
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

        const name = testName + (optimize ? "Opt" : "Unopt");
        const code = '0x' + binRuntime;

        const filler = generators[testName] ? generators[testName](name, code) : generateDefaultTestFiller(name, code);

        const fillerPath = path.join(FILLERS_PATH, name + "Filler.json");
        const fillerData = JSON.stringify(filler, null, '\t');
        fs.writeFileSync(fillerPath, fillerData);
    }
};