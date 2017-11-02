import {readJSON} from "./io";
import {DATA_FILE, DATA_PATH} from "../constants";

import * as path from "path";

export const getAllPackageNames = (): string[] => {
    const dataJSON = readJSON(DATA_FILE);
    return Object.keys(dataJSON["packages"]).sort();
};

export const getAllData = (): object => {
    const dataJSON = readJSON(DATA_FILE);
    const data = {
        packages: {}
    };
    const packagesJSON = dataJSON["packages"];
    for (const pkg in packagesJSON) {
        if (packagesJSON.hasOwnProperty(pkg)) {
            data.packages[pkg] = readJSON(path.join(DATA_PATH, packagesJSON[pkg]));
        }
    }
    return data;
};

export const getAllContractsFromData = (data: object): Array<[string, object]> => {
    const contracts: Array<[string, object]> = [];
    const packages = data["packages"];
    for (const pkg in packages) {
        if (packages.hasOwnProperty(pkg)) {
            const contractsJSON = packages[pkg]["contracts"];
            if (contractsJSON && contractsJSON instanceof Array && contractsJSON.length > 0) {
                for (const contract of contractsJSON) {
                    contracts.push([pkg, contract]);
                }
            }
        }
    }
    return contracts;
};

export const getAllContracts = (): Array<[string, object]> => {
    return getAllContractsFromData(getAllData());
};

export const getAllContractFilesFromContractData = (contracts: Array<[string, object]>): Array<[string, string]> => {
    const contractFiles: Array<[string, string]> = [];
    for (const contractData of contracts) {
        const pkg = contractData[0];
        const contract = contractData[1];
        const cName = contract["name"];
        if (!cName) {
            throw new Error(`Error reading from contract data for ${pkg}: contract has no name.`);
        }
        contractFiles.push([pkg, cName]);
    }

    return contractFiles;
};

export const getAllContractFiles = (): Array<[string, string]> => {
    return getAllContractFilesFromContractData(getAllContracts());
};

export const getAllTestFilesFromContractData = (contracts: Array<[string, object]>, extended: boolean = false): Array<[string, string]> => {
    const contractFiles: Array<[string, string]> = [];
    for (const contractData of contracts) {
        const pkg = contractData[0];
        const contract = contractData[1];
        const cName = contract["name"];
        if (!cName) {
            throw new Error(`Error reading from contract data for ${pkg}: contract has no name.`);
        }
        const tests = contract["tests"];
        if (tests) {
            if (!(tests instanceof Array)) {
                throw new Error(`Malformed tests for ${pkg}/${cName}: tests is not an array.`);
            }
            for (const test of tests) {
                const tName = test["name"];
                if (!tName) {
                    throw new Error(`Malformed tests for ${pkg}/${cName}: test has no name.`);
                }
                if (extended || !test["extended"]) {
                    contractFiles.push([pkg, tName]);
                }
            }
        }
    }
    return contractFiles;
};

export const getAllTestFiles = (extended: boolean = false): Array<[string, string]> => {
    return getAllTestFilesFromContractData(getAllContracts(), extended);
};

export const getAllPerfFilesFromContractData = (contracts: Array<[string, object]>, extended: boolean = false): Array<[string, string]> => {
    const contractFiles: Array<[string, string]> = [];
    for (const contractData of contracts) {
        const pkg = contractData[0];
        const contract = contractData[1];
        const cName = contract["name"];
        if (!cName) {
            throw new Error(`Error reading from contract data for ${pkg}: contract has no name.`);
        }
        const perf = contract["perf"];
        if (perf) {
            if (!(perf instanceof Array)) {
                throw new Error(`Malformed perf for ${pkg}/${cName}: perf is not an array.`);
            }
            for (const p of perf) {
                const pName = p["name"];
                if (!pName) {
                    throw new Error(`Malformed perf for ${pkg}/${cName}: perf has no name.`);
                }
                if (extended || !p["extended"]) {
                    contractFiles.push([pkg, pName]);
                }
            }
        }
    }
    return contractFiles;
};

export const getAllPerfFiles = (extended: boolean = false): Array<[string, string]> => {
    return getAllPerfFilesFromContractData(getAllContracts(), extended);
};
