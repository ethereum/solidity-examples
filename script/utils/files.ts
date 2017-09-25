import * as fs from 'fs';
import * as mkdirp from 'mkdirp';
import * as path from 'path';

export const rmrf = (path: string): void => {
    if (fs.existsSync(path)) {
        fs.readdirSync(path).forEach(function (file, index) {
            let curPath = path + "/" + file;
            if (fs.lstatSync(curPath).isDirectory()) { // recurse
                rmrf(curPath);
            } else { // delete file
                fs.unlinkSync(curPath);
            }
        });
        fs.rmdirSync(path);
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

export const writeLog = (log: Object, dir: string, name: string): void => {
    const optResultsPath = path.join(dir, name);
    fs.writeFileSync(optResultsPath, JSON.stringify(log, null, '\t'));
    console.info(`Logs written to: ${optResultsPath}`);
};

export const readLog = (dir: string, name: string): Object => {
    const latestOptStr = fs.readFileSync(path.join(dir, name)).toString();
    return JSON.parse(latestOptStr);
};

export const isSigInHashes = (dir: string, sigfile: string, sig: string): boolean => {

    const hashes = fs.readFileSync(path.join(dir, sigfile)).toString();
    const lines = hashes.split(/\r\n|\r|\n/);
    if (lines.length === 0) {
        throw new Error(`No methods found in signatures: ${sigfile}`);
    }
    let perfFound = false;
    for (let i = 0; i < lines.length; i++) {

        const line = lines[i].trim();
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
            return true;
        }
    }
    return false;
};