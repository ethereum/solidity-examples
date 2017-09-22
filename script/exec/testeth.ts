import * as child from 'child_process';
import {TESTETH_PATH} from "../constants";
const execSync = child.execSync;

export const testeth = (): string => {
    const cmd = `testeth -t GeneralStateTests/stSolidityTest -- --statediff --testpath  ${TESTETH_PATH} --filltests`;
    const ret = execSync(cmd, {stdio: 'inherit'});
    return ret !== null ? ret.toString(): "";
};

export const version = (): string => {
    const cmd = `testeth --version`;
    const ret = execSync(cmd);
    return ret !== null ? ret.toString(): "";
};