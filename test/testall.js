const stl = require('../stl');

try {
    stl.testAll(false);
} catch (err) {
    console.error("Execution failed: " + err.message);
    process.exit(1);
}