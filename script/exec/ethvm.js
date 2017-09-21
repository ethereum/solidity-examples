"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
var fs = require('fs');
var path = require('path');
var constants = require("../constants");
var child = require('child_process');
var execSync = child.execSync;
exports.perf = function (code) {
    var cmd = "ethvm --code " + code + " --input " + constants.PERF_FUN_HASH;
    var ret = execSync(cmd);
    return ret.toString();
};
exports.version = function () {
    return execSync('ethvm --version').toString();
};
