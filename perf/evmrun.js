const fs = require('fs');
const child = require('child_process');
const execSync = child.execSync;

function runFile(binFile, input) {
    const code = fs.readFileSync(binFile).toString();
    run(code, input);
}

function run(code, input) {
    console.log(execSync("evm --dump --codefile " + code + " --input " + input));
}

function version() {
    return execSync("evm --version").toString();
}

module.exports = {
    runFile: runFile,
    run: run,
    version: version
};