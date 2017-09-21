"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
var constants = require("../constants");
var child = require("child_process");
var execSync = child.execSync;
exports.testeth = function () {
    return execSync("testeth -t GeneralStateTests/stSolidityTest -- --statediff --testpath  " + constants.TESTETH_PATH + " --filltests", { stdio: 'inherit' }).toString();
};
