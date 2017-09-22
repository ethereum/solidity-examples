"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
var child = require("child_process");
var constants_1 = require("../constants");
var execSync = child.execSync;
exports.perf = function (file) {
    var cmd = "evm --codefile " + file + " --input " + constants_1.PERF_FUN_HASH + " run";
    var ret = execSync(cmd);
    return ret !== null ? ret.toString() : "";
};
exports.test = function (file) {
    var cmd = "evm --codefile " + file + " --input " + constants_1.TEST_FUN_HASH + " run";
    var ret = execSync(cmd);
    return ret !== null ? ret.toString() : "";
};
exports.version = function () {
    return execSync('evm --version').toString();
};
