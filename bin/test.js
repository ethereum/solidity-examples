"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
var createTests = require("../script/createTests");
try {
    createTests.testAll(false);
} catch (err) {
    console.error("Execution failed: " + err.message);
    process.exit(1);
}
