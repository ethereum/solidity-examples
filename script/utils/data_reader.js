"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
var io_1 = require("./io");
var constants_1 = require("../constants");
var path = require("path");
exports.getAllPackageNames = function () {
    var dataJSON = io_1.readJSON(constants_1.DATA_FILE);
    return Object.keys(dataJSON["packages"]).sort();
};
exports.getAllData = function () {
    var dataJSON = io_1.readJSON(constants_1.DATA_FILE);
    var data = {
        packages: {}
    };
    var packagesJSON = dataJSON["packages"];
    for (var pkg in packagesJSON) {
        if (packagesJSON.hasOwnProperty(pkg)) {
            data.packages[pkg] = io_1.readJSON(path.join(constants_1.DATA_PATH, packagesJSON[pkg]));
        }
    }
    return data;
};
exports.getAllContractsFromData = function (data) {
    var contracts = [];
    var packages = data["packages"];
    for (var pkg in packages) {
        if (packages.hasOwnProperty(pkg)) {
            var contractsJSON = packages[pkg]["contracts"];
            if (contractsJSON && contractsJSON instanceof Array && contractsJSON.length > 0) {
                for (var _i = 0, contractsJSON_1 = contractsJSON; _i < contractsJSON_1.length; _i++) {
                    var contract = contractsJSON_1[_i];
                    contracts.push([pkg, contract]);
                }
            }
        }
    }
    return contracts;
};
exports.getAllContracts = function () {
    return exports.getAllContractsFromData(exports.getAllData());
};
exports.getAllContractFilesFromContractData = function (contracts) {
    var contractFiles = [];
    for (var _i = 0, contracts_1 = contracts; _i < contracts_1.length; _i++) {
        var contractData = contracts_1[_i];
        var pkg = contractData[0];
        var contract = contractData[1];
        var cName = contract["name"];
        if (!cName) {
            throw new Error("Error reading from contract data for " + pkg + ": contract has no name.");
        }
        contractFiles.push([pkg, cName]);
    }
    return contractFiles;
};
exports.getAllContractFiles = function () {
    return exports.getAllContractFilesFromContractData(exports.getAllContracts());
};
exports.getAllTestFilesFromContractData = function (contracts, extended) {
    if (extended === void 0) { extended = false; }
    var contractFiles = [];
    for (var _i = 0, contracts_2 = contracts; _i < contracts_2.length; _i++) {
        var contractData = contracts_2[_i];
        var pkg = contractData[0];
        var contract = contractData[1];
        var cName = contract["name"];
        if (!cName) {
            throw new Error("Error reading from contract data for " + pkg + ": contract has no name.");
        }
        var tests = contract["tests"];
        if (tests) {
            if (!(tests instanceof Array)) {
                throw new Error("Malformed tests for " + pkg + "/" + cName + ": tests is not an array.");
            }
            for (var _a = 0, tests_1 = tests; _a < tests_1.length; _a++) {
                var test_1 = tests_1[_a];
                var tName = test_1["name"];
                if (!tName) {
                    throw new Error("Malformed tests for " + pkg + "/" + cName + ": test has no name.");
                }
                if (extended || !test_1["extended"]) {
                    contractFiles.push([pkg, tName]);
                }
            }
        }
    }
    return contractFiles;
};
exports.getAllTestFiles = function (extended) {
    if (extended === void 0) { extended = false; }
    return exports.getAllTestFilesFromContractData(exports.getAllContracts(), extended);
};
exports.getAllPerfFilesFromContractData = function (contracts, extended) {
    if (extended === void 0) { extended = false; }
    var contractFiles = [];
    for (var _i = 0, contracts_3 = contracts; _i < contracts_3.length; _i++) {
        var contractData = contracts_3[_i];
        var pkg = contractData[0];
        var contract = contractData[1];
        var cName = contract["name"];
        if (!cName) {
            throw new Error("Error reading from contract data for " + pkg + ": contract has no name.");
        }
        var perf = contract["perf"];
        if (perf) {
            if (!(perf instanceof Array)) {
                throw new Error("Malformed perf for " + pkg + "/" + cName + ": perf is not an array.");
            }
            for (var _a = 0, perf_1 = perf; _a < perf_1.length; _a++) {
                var p = perf_1[_a];
                var pName = p["name"];
                if (!pName) {
                    throw new Error("Malformed perf for " + pkg + "/" + cName + ": perf has no name.");
                }
                if (extended || !p["extended"]) {
                    contractFiles.push([pkg, pName]);
                }
            }
        }
    }
    return contractFiles;
};
exports.getAllPerfFiles = function (extended) {
    if (extended === void 0) { extended = false; }
    return exports.getAllPerfFilesFromContractData(exports.getAllContracts(), extended);
};
