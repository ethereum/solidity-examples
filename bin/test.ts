import tests = require('../script/tests');

try {
    tests.testAll(true, false);
} catch (err) {
    console.error("Execution failed: " + err.message);
    process.exit(1);
}