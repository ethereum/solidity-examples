const fs = require('fs');
const path = require('path');
import constants = require('../constants');
const child = require('child_process');
const execSync = child.execSync;

export const perf = (code: string): string => {
    const cmd = `ethvm --code ${code} --input ${constants.PERF_FUN_HASH}`;
    const ret = execSync(cmd);
    return ret.toString();
};

export const version = (): string => {
    return execSync('ethvm --version').toString();
};