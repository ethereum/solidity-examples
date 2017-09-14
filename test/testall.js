const stl = require('../stl');

var docker = process.argv.length === 3 && process.argv[2] === "docker";

try {
    stl.testAll(true, docker);
} catch (err) {
    console.error("Execution failed: " + err.message);
    process.exit(1);
}