"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
var constants = require("../constants");
var path = require("path");
var child = require("child_process");
var execSync = child.execSync;
function compileTest(subdir, test, optimize) {
    if (optimize === void 0) { optimize = true; }
    var cmd = "solc .= --bin-runtime --hashes --overwrite " + (optimize ? "--optimize" : "") + " -o " + constants.TEST_BIN + " " + path.join(constants.TEST_CONTRACT_PATH, subdir, test + '_tests.sol');
    var ret = execSync(cmd, { cwd: constants.ROOT_PATH });
    return ret.toString();
}
exports.compileTest = compileTest;
function compilePerf(subdir, perf, optimize) {
    if (optimize === void 0) { optimize = true; }
    var cmd = "solc .= --bin-runtime --hashes --overwrite " + (optimize ? "--optimize" : "") + " -o " + constants.PERF_BIN + " " + path.join(constants.PERF_CONTRACT_PATH, subdir, perf + '_perfs.sol');
    var ret = execSync(cmd, { cwd: constants.ROOT_PATH });
    return ret.toString();
}
exports.compilePerf = compilePerf;
function version() {
    return execSync('solc --version').toString();
}
exports.version = version;
