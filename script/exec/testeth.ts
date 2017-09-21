import constants = require('../constants');
import child = require('child_process');
const execSync = child.execSync;

export const testeth = (): string => {
    return execSync(`testeth -t GeneralStateTests/stSolidityTest -- --statediff --testpath  ${constants.TESTETH_PATH} --filltests`, {stdio: 'inherit'}).toString();
};