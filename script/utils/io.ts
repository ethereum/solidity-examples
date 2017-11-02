import * as fs from 'fs';
import * as mkdirp from 'mkdirp';
import * as path from 'path';
import Logger from "./logger";
import {PERF_LOGS_PATH, RESULTS_NAME_OPTIMIZED, RESULTS_NAME_UNOPTIMIZED, TEST_LOGS_PATH} from "../constants";

export const print = (text: string) => {
    process.stdout.write(text);
};

export const println = (text: string) => {
    process.stdout.write(text + '\n');
};

export const readText = (filePath: string): string => {
    return fs.readFileSync(filePath).toString();
};

export const readJSON = (filePath: string): object => {
    return JSON.parse(readText(filePath));
};

export const rmrf = (pth: string): void => {
    if (fs.existsSync(pth)) {
        fs.readdirSync(pth).forEach((file) => {
            const curPath = pth + "/" + file;
            if (fs.lstatSync(curPath).isDirectory()) { // recurse
                rmrf(curPath);
            } else { // delete file
                fs.unlinkSync(curPath);
            }
        });
        fs.rmdirSync(pth);
    }
};

export const ensureAndClear = (dir: string): void => {
    rmrf(dir);
    mkdirp.sync(dir);
};

export const createTimestampSubfolder = (root: string): string => {
    const folder = new Date().getTime().toString(10);
    const logPath = path.join(root, folder);
    mkdirp.sync(logPath);
    return logPath;
};

export const readLatest = (dir: string): string => {
    const latestFile = path.join(dir, 'latest');
    if (!fs.existsSync(latestFile)) {
        return "";
    }
    return fs.readFileSync(latestFile).toString();
};

export const writeLatest = (dir: string, data: string) => {
    const latestFile = path.join(dir, 'latest');
    if (!fs.existsSync(latestFile)) {
        mkdirp.sync(dir);
    }
    fs.writeFileSync(latestFile, data);
};

export const writeLog = (log: object, dir: string, name: string): void => {
    const optResultsPath = path.join(dir, name);
    fs.writeFileSync(optResultsPath, JSON.stringify(log, null, '\t'));
    Logger.info(`Logs written to: ${optResultsPath}`);
};

export const readLog = (dir: string, name: string): object => readJSON(path.join(dir, name));

export const latestPerfLog = (optimized: boolean = true): object => {
    const latest = readLatest(PERF_LOGS_PATH);
    if (latest === '') {
        throw new Error(`No perf-logs found.`);
    }
    const file = optimized ? RESULTS_NAME_OPTIMIZED : RESULTS_NAME_UNOPTIMIZED;
    return readLog(latest, file);
};

export const latestTestLog = (optimized: boolean = true): object => {
    const latest = readLatest(TEST_LOGS_PATH);
    if (latest === '') {
        throw new Error(`No test-logs found.`);
    }
    const file = optimized ? RESULTS_NAME_OPTIMIZED : RESULTS_NAME_UNOPTIMIZED;
    return readLog(latest, file);
};

export const indexedLogFolders = (baseDir: string, maxEntries: number = 20): string[] => {
    const files = fs.readdirSync(baseDir);
    const logFolders = files.filter((file) => {
        if (!fs.statSync(path.join(baseDir, file)).isDirectory()) {
            return false;
        }
        const num = parseInt(file, 10);
        return !isNaN(num) && num > 0;
    }).sort().reverse();
    return logFolders.length > maxEntries ? logFolders.slice(0, maxEntries) : logFolders;
};

export const isSigInHashes = (dir: string, sigfile: string, sig: string): boolean => {

    const hashes = fs.readFileSync(path.join(dir, sigfile)).toString();
    const lines = hashes.split(/\r\n|\r|\n/);
    if (lines.length === 0) {
        throw new Error(`No methods found in signatures: ${sigfile}`);
    }
    let perfFound = false;
    for (let line of lines) {

        line = line.trim();
        if (line.length === 0) {
            continue;
        }
        const tokens = line.split(':');
        if (tokens.length !== 2) { // Should never happen with well formed signature files.
            throw new Error(`No ':' separator in line: '${line}' in signatures: ${sigfile}`);
        }
        const hash = tokens[0].trim();
        if (hash === sig) {
            if (perfFound) { // Should never happen with well formed signature files.
                throw new Error(`Repeated hash of perf function in signature file: ${sigfile}`);
            }
            perfFound = true;
        }
    }
    return perfFound;
};
