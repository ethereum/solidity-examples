const fs = require('fs');
const path = require('path');
const child = require('child_process');
const execSync = child.execSync;
const fillerUtils = require('./script/fillerUtils');
const mkdirp = require('mkdirp');

const bitsGenerators = require('./test/bits/generators');
const bytesGenerators = require('./test/bytes/generators');
const rlpGenerators = require('./test/rlp/generators');
const patriciaTrieGenerators = require('./test/patricia_tree/generators');
const unsafeGenerators = require('./test/unsafe/generators');

const TESTS = [
    ['bits', 'bits_tests.sol', bitsGenerators]
    //['bytes', 'bytes_tests.sol', bytesGenerators],
    //['rlp', 'rlp_reader_tests.sol', rlpGenerators],
    //['patricia_tree', 'patricia_tree_tests.sol', patriciaTrieGenerators],
    //['unsafe', 'memory_tests.sol', unsafeGenerators]
];

const ROOT_PATH = __dirname;
const BASE_CONTRACT_PATH = path.join(ROOT_PATH, 'test');
const TESTETH_PATH = path.join(ROOT_PATH, 'testeth');
const TEST_BIN = path.join(TESTETH_PATH, 'test_bin');
const TESTS_PATH = path.join(TESTETH_PATH, 'GeneralStateTests', 'stSolidityTest');
const FILLERS_PATH = path.join(TESTETH_PATH, 'src', 'GeneralStateTestsFiller', 'stSolidityTest');
const TEST_FUN_HASH = 'f8a8fd6d';

const generators = {};

function registerTests() {
    for (var i = 0; i < TESTS.length; i++) {
        const gens = TESTS[i][2];
        const tests = gens();
        for(var test in tests) {
            if(tests.hasOwnProperty(test)){
                if(generators[test]) {
                    throw new Error("Multiple generators for ");
                }
                generators[test] = tests[test];
            }
        }
    }
}

function testAll(optAndUnopt, docker) {
    registerTests();
    rmrf(TESTS_PATH);
    rmrf(FILLERS_PATH);
    mkdirp.sync(FILLERS_PATH);

    rmrf(TEST_BIN);
    mkdirp.sync(TEST_BIN);
    compileAndGenerateFillers(true, docker);
    if (optAndUnopt) {
        rmrf(TEST_BIN);
        fs.mkdirSync(TEST_BIN);
        compileAndGenerateFillers(false, docker);
    }
    testeth(docker);
}

function compileAndGenerateFillers(optimize, docker) {

    for (var i = 0; i < TESTS.length; i++) {
        const subDir = TESTS[i][0];
        const test = TESTS[i][1];
        compile(subDir, test, false, docker);
    }
    generateFillers(optimize);
}

function testeth(docker) {
    if (docker) {
        execSync("docker run -v " + TESTETH_PATH + ":/testeth holiman/testeth -t GeneralStateTests/stSolidityTest -- --statediff --testpath /testeth --filltests");
    } else {
        execSync("testeth -t GeneralStateTests/stSolidityTest -- --statediff --testpath " + TESTETH_PATH + " --filltests", {stdio: 'inherit'});
    }

}

function compile(subDir, testName, optimize, docker) {
    if (typeof subDir !== 'string' || subDir === '' || typeof testName !== 'string' || testName === '') {
        throw new Error("Arguments 'subDir' and 'testName' must both be non-empty strings");
    }
    if (docker) {
        const dcmd = "docker run -v " + ROOT_PATH + ":/solidity-examples ethereum/solc:stable /solidity-examples= --bin-runtime --hashes --overwrite " + (optimize ? "--optimize " : "") + "-o /solidity-examples/testeth/test_bin " + path.join("/solidity-examples", "test", subDir, testName);
        execSync(dcmd);
    } else {
        const versionString = execSync("solc --version");
        const cmd = "solc .= --bin-runtime --hashes --overwrite " + (optimize ? "--optimize " : "") + "-o " + TEST_BIN + " " + path.join(BASE_CONTRACT_PATH, subDir, testName);
        const ret = execSync(cmd);
        console.log(ret.toString());
        fs.writeFileSync(path.join(TEST_BIN, testName + ".compver"), versionString);
    }
}

function generateFillers(optimize) {

    const files = fs.readdirSync(TEST_BIN);
    const sigfiles = files.filter(function (file) {
        const f = file.trim();
        return f.length > 4 && f.substr(0, 4) === 'Test' && f.split('.').pop() === 'signatures';
    });
    for (var j = 0; j < sigfiles.length; j++) {
        const sigfile = sigfiles[j];
        const testName = sigfile.substr(0, sigfile.length - 11);
        const binRuntimePath = path.join(TEST_BIN, testName + ".bin-runtime");
        const hashesPath = path.join(TEST_BIN, sigfile);
        const binRuntime = fs.readFileSync(binRuntimePath).toString();
        const hashes = fs.readFileSync(hashesPath).toString();

        const lines = hashes.split(/\r\n|\r|\n/);
        if (lines.length === 0) {
            throw new Error("No methods in: " + testName);
        }
        var testFound = false;
        for (var i = 0; i < lines.length; i++) {

            const line = lines[i].trim();
            if (line.length === 0) {
                continue;
            }
            const tokens = line.split(':');
            if (tokens.length !== 2) {
                throw new Error("No : separator in line: " + line);
            }
            const hash = tokens[0].trim();
            if (hash === TEST_FUN_HASH) {
                if (testFound) {
                    throw new Error("Repeated hash of test function in file: " + hashes);
                }
                testFound = true;
            }
        }
        if (!testFound) {
            throw new Error("Contract has no test: " + hashes);
        }

        const name = testName + (optimize ? "Opt" : "Unopt");
        const code = '0x' + binRuntime;

        const filler = generators[testName] ? generators[testName](name, code) : fillerUtils.generateDefaultTestFiller(name, code);

        const fillerPath = path.join(FILLERS_PATH, name + "Filler.json");
        const fillerData = JSON.stringify(filler, null, '\t');
        fs.writeFileSync(fillerPath, fillerData);
    }
}

function rmrf(path) {
    if (fs.existsSync(path)) {
        fs.readdirSync(path).forEach(function (file, index) {
            var curPath = path + "/" + file;
            if (fs.lstatSync(curPath).isDirectory()) { // recurse
                rmrf(curPath);
            } else { // delete file
                fs.unlinkSync(curPath);
            }
        });
        fs.rmdirSync(path);
    }
}

module.exports = {
    testAll: testAll,
    compileAndGenerateFillers: compileAndGenerateFillers,
    generateFillers: generateFillers,
    compile: compile,
    testeth: testeth
};