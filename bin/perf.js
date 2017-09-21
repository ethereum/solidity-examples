"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
var createPerf = require("../script/createPerf");
try {
    createPerf.perfAll(false);
}
catch (err) {
    console.log(err);
    console.error("Execution failed: " + err.message);
    process.exit(1);
}
