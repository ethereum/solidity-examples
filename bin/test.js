"use strict";
exports.__esModule = true;
var tests = require("../script/tests");
try {
    tests.testAll(true, false);
}
catch (err) {
    console.error("Execution failed: " + err.message);
    process.exit(1);
}
