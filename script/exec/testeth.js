"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
var child = require("child_process");
var constants_1 = require("../constants");
var execSync = child.execSync;
exports.testeth = function () {
    var cmd = "testeth -t GeneralStateTests/stSolidityTest -- --statediff --testpath  " + constants_1.TESTETH_PATH + " --filltests";
    var ret = execSync(cmd, { stdio: 'inherit' });
    return ret !== null ? ret.toString() : "";
};
exports.version = function () {
    var cmd = "testeth --version";
    var ret = execSync(cmd);
    return ret !== null ? ret.toString() : "";
};
