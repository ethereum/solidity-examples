import * as fs from 'fs';
import * as path from 'path';
import {PERF_BIN, PERF_FUN_HASH, PERF_LOGS, UNITS} from "./constants";
import {rmrf} from "./utils/files";
import {compilePerf, version as solcVersion} from "./exec/solc";
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
    mkdirp.sync(logPath);
    const ret = compileAndRunPerf(true);

    const log = {
        solcVersion: solcV,
        ethvmVersion: ethvmV,
        results: ret
    };
    const logStr = JSON.stringify(log, null, '\t');
    const optResultsPath = path.join(logPath, "results_optimized.json");
    fs.writeFileSync(optResultsPath, logStr);
    console.log(`Logs printed to: ${optResultsPath}`);
    let logU: Object = null;
    if (optAndUnopt) {
        rmrf(PERF_BIN);
        fs.mkdirSync(PERF_BIN);
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
        compilePerf(subDir, test, false);
    }
    return runPerf(optimize);
};

export const runPerf = (optimize: boolean): Object => {

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

    // Operations
    const opsinIdx = lines[3].indexOf('operations in');
    if (opsinIdx <= 0) {
        throw new Error(`Malformed ethvm output (line 4):\n ${output}`);
    }
    const ops = parseInt(lines[3].substring(0, opsinIdx - 1).trim(), 10);

    // Maximum mem usage.
    if (lines[4].indexOf('Maximum memory usage:') !== 0) {
        throw new Error(`Malformed ethvm output (line 5):\n ${output}`);
    }
    const mmuSplit = lines[4].split(':');
    if (mmuSplit.length !== 2) {
        throw new Error(`Malformed ethvm output (line 5):\n ${output}`);
    }
    const musgStr = mmuSplit[1].trim();
    const bytesIdx = musgStr.indexOf('bytes');
    if (bytesIdx <= 0) {
        throw new Error(`Malformed ethvm output (line 5):\n ${output}`);
    }
    const maxMemUsage = parseInt(musgStr.substring(0, bytesIdx - 1).trim(), 16);

    // Expensive operations
    let expOps: {[operation: string]: number} = {};
    if (lines[5].indexOf('Expensive operations:') === 0) {
        for(let i = 6; i < lines.length && lines[i].trim() !== ""; i++) {
            const expOpStr = lines[i].trim();
            const idxX = expOpStr.indexOf(' x ');
            if (idxX <= 0) {
                throw new Error(`Malformed ethvm output (line ${i}):\n ${output}`);
            }
            const idxLP = expOpStr.indexOf('(');
            if (idxLP <= 0) {
                throw new Error(`Malformed ethvm output (line ${i}):\n ${output}`);
            }
            const expOp = expOpStr.substring(0, idxX).trim();
            const numUsed = parseInt(expOpStr.substring(idxX + 2, idxLP - 1).trim(), 10);
            expOps[expOp] = numUsed;
        }
    }

    return {
        gasUsed: gasUsed,
        ops: ops,
        maxMemUsage: maxMemUsage,
        expensiveOps: expOps
    };
};