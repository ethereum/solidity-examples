"use strict";
exports.__esModule = true;
var createTests = require("../script/createTests");
try {
    createTests.testAll(true, false);
}
catch (err) {
    console.error("Execution failed: " + err.message);
    process.exit(1);
}
