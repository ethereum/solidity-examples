import perf = require('../script/perf');

try {
    perf.perfAll(true);
} catch (err) {
    console.error("Execution failed: " + err.message);
    process.exit(1);
}