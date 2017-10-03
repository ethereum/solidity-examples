import * as child from 'child_process';
const execSync = child.execSync;

export const run = (file: string, input: string): string => {
    const cmd = `evm --codefile ${file} --input ${input} run`;
    const ret = execSync(cmd);
    if (ret === null) {
        throw new Error(`Failed when running command: ${cmd}`);
    }
    if (ret === null) {
        throw new Error(`Failed when running command: ${cmd}`);
    }
    const retStr = ret.toString();
    if (retStr.length === 0) {
        throw new Error(`Failed when running command: ${cmd}`);
    }
    const res = retStr.substring(0, retStr.indexOf('\n')).trim();
    return res === '0x' ? '0' : res.substr(2);
};

export const version = (): string => {
    return execSync('evm --version').toString().trim();
};
