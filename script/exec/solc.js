"use strict";
exports.__esModule = true;
var path = require("path");
var child = require("child_process");
var constants_1 = require("../constants");
var execSync = child.execSync;
function compileTest(subdir, test, optimize) {
    if (optimize === void 0) { optimize = true; }
    var cmd = "solc .= --bin-runtime --hashes --overwrite " + (optimize ? "--optimize" : "") + " -o " + constants_1.TEST_BIN + " " + path.join(constants_1.TEST_CONTRACT_PATH, subdir, test + '_tests.sol');
    var ret = execSync(cmd, { cwd: constants_1.ROOT_PATH });
    return ret.toString();
}
exports.compileTest = compileTest;
function compilePerf(subdir, perf, optimize) {
    if (optimize === void 0) { optimize = true; }
    var cmd = "solc .= --bin-runtime --hashes --overwrite " + (optimize ? "--optimize" : "") + " -o " + constants_1.PERF_BIN + " " + path.join(constants_1.PERF_CONTRACT_PATH, subdir, perf + '_perfs.sol');
    var ret = execSync(cmd, { cwd: constants_1.ROOT_PATH });
    return ret.toString();
}
exports.compilePerf = compilePerf;
function compileRuntime(file, optimize) {
    if (optimize === void 0) { optimize = true; }
    var cmd = "solc .= --bin-runtime " + (optimize ? "--optimize" : "") + " " + file;
    var ret = execSync(cmd, { cwd: constants_1.ROOT_PATH });
    return ret.toString();
}
exports.compileRuntime = compileRuntime;
function version() {
    var verStr = execSync('solc --version').toString();
    return verStr.substr(verStr.indexOf('\n')).trim();
}
exports.version = version;
