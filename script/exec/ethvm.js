"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
var child = require("child_process");
var constants_1 = require("../constants");
var execSync = child.execSync;
exports.perf = function (code) {
    var cmd = "ethvm --code " + code + " --input " + constants_1.PERF_FUN_HASH;
    var ret = execSync(cmd);
    return ret !== null ? ret.toString() : "";
};
exports.version = function () {
    return execSync('ethvm --version').toString();
};
