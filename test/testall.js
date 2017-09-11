const stl = require('../stl');

try {
    stl.testAll(true);
} catch (err) {
    console.error("Execution failed: " + err.message);
    process.exit(1);
}