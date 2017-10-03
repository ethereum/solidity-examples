"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
var child = require("child_process");
var execSync = child.execSync;
exports.run = function (file, input) {
    var cmd = "evm --codefile " + file + " --input " + input + " run";
    var ret = execSync(cmd);
    if (ret === null) {
        throw new Error("Failed when running command: " + cmd);
    }
    if (ret === null) {
        throw new Error("Failed when running command: " + cmd);
    }
    var retStr = ret.toString();
    if (retStr.length === 0) {
        throw new Error("Failed when running command: " + cmd);
    }
    var res = retStr.substring(0, retStr.indexOf('\n')).trim();
    return res === '0x' ? '0' : res.substr(2);
};
exports.version = function () {
    return execSync('evm --version').toString().trim();
};
