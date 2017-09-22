import * as fs from 'fs';
import * as path from 'path';
import {PERF_BIN, PERF_CONTRACT_PATH, PERF_FUN_HASH, PERF_LOGS, UNITS} from "./constants";
import {rmrf} from "./utils/files";
import {compilePerf, compileRuntime, version as solcVersion} from "./exec/solc";
import {perf, version as ethvmVersion} from './exec/ethvm';
import * as mkdirp from 'mkdirp';
import * as jsondiffpatch from 'jsondiffpatch';

export const perfAll = (optAndUnopt: boolean): void => {
    const solcV = solcVersion().split(/\r\n|\r|\n/)[1].trim();
    const ethvmV = ethvmVersion().split(/\r\n|\r|\n/)[0].trim();
    rmrf(PERF_BIN);
    mkdirp.sync(PERF_BIN);

    const folder = new Date().getTime().toString(10);
    const logPath = path.join(PERF_LOGS, folder);

    const ret = compileAndRunPerf(true);

    const log = {
        solcVersion: solcV,
        ethvmVersion: ethvmV,
        results: ret
    };
    const logStr = JSON.stringify(log, null, '\t');
    mkdirp.sync(logPath);
    const optResultsPath = path.join(logPath, "results_optimized.json");
    fs.writeFileSync(optResultsPath, logStr);
    console.log(`Logs printed to: ${optResultsPath}`);
    let logU: Object = null;
    if (optAndUnopt) {
        rmrf(PERF_BIN);
        mkdirp.sync(PERF_BIN);
        const retU = compileAndRunPerf(false);
        logU = {
            solcVersion: solcV,
            ethvmVersion: ethvmV,
            results: retU
        };
        const logStrU = JSON.stringify(logU, null, '\t');
        const unoptResultsPath = path.join(logPath, "results_unoptimized.json");
        fs.writeFileSync(unoptResultsPath, logStrU);
        console.log(`Logs printed to: ${optResultsPath}`);
    }
    const latestFile = path.join(PERF_LOGS, 'latest');
    if (fs.existsSync(latestFile)) {
        const latest = fs.readFileSync(latestFile).toString();
        const latestOptStr = fs.readFileSync(path.join(PERF_LOGS, latest, "results_optimized.json")).toString();
        const latestOptResults = JSON.parse(latestOptStr);
        const diff = jsondiffpatch.diff(latestOptResults, log);
        if (diff) {
            const output = jsondiffpatch.formatters.console.format(diff);
            console.log("Changes since last run:");
            console.log(output);
        }
        if (optAndUnopt) {
            const latestUnOptFile = path.join(PERF_LOGS, latest, "results_unoptimized.json");
            if (fs.existsSync(latestUnOptFile)) {
                const latestUnOptStr = fs.readFileSync(latestUnOptFile).toString();
                const latestUnOptResults = JSON.parse(latestUnOptStr);
                const diff = jsondiffpatch.diff(latestUnOptResults, logU);
                if (diff) {
                    const output = jsondiffpatch.formatters.console.format(diff);
                    console.log("Changes since last run:");
                    console.log(output);
                }
            }
        }
    }

    fs.writeFileSync(latestFile, folder);
};

export const compileAndRunPerf = (optimize: boolean): Object => {
    for (let i = 0; i < UNITS.length; i++) {
        const subDir = UNITS[i][0];
        const test = UNITS[i][1];
        compilePerf(subDir, test, optimize);
    }
    return runPerf();
};

export const runPerf = (): Object => {

    const files = fs.readdirSync(PERF_BIN);
    const sigfiles = files.filter(function (file) {
        const f = file.trim();
        return f.length > 4 && f.substr(0, 4) === 'Perf' && f.split('.').pop() === 'signatures';
    });
    const log = {};
    for (let j = 0; j < sigfiles.length; j++) {
        const sigfile = sigfiles[j];
        const perfName = sigfile.substr(0, sigfile.length - 11);
        const binRuntimePath = path.join(PERF_BIN, perfName + ".bin-runtime");
        const hashesPath = path.join(PERF_BIN, sigfile);
        const binRuntime = fs.readFileSync(binRuntimePath).toString();
        const hashes = fs.readFileSync(hashesPath).toString();

        const lines = hashes.split(/\r\n|\r|\n/);
        if (lines.length === 0) {
            throw new Error("No methods in: " + perfName);
        }
        let perfFound = false;
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
            if (hash === PERF_FUN_HASH) {
                if (perfFound) {
                    throw new Error("Repeated hash of perf function in file: " + hashes);
                }
                perfFound = true;
            }
        }
        if (!perfFound) {
            throw new Error("Contract has no perf: " + hashes);
        }

        const code = '0x' + binRuntime;
        const result = perf(code);

        log[perfName] = parseData(result);
    }
    return log;
};

const parseData = (output: string): Object => {

    const lines = output.split(/\r\n|\r|\n/);

    if (lines[0].indexOf('Gas used') !== 0) {
        throw new Error(`Malformed ethvm output (line 1):\n ${output}`);
    }
    // Output
    if (lines[1].indexOf('Output:') !== 0) {
        throw new Error(`Malformed ethvm output (line 2):\n ${output}`);
    }
    const outputSplit = lines[1].split(':');
    if (outputSplit.length !== 2) {
        throw new Error(`Malformed ethvm output (line 2):\n ${output}`);
    }
    const gasUsed = parseInt(outputSplit[1].trim(), 16);


    return {
        gasUsed: gasUsed
    };
};