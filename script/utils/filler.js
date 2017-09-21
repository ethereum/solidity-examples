"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
var ZSchema = require("z-schema");
var schema = require('../st-filler-schema.json');
exports.generateDefaultTestFiller = function (name, code) {
    var ohex = /Throws/.test(name) ? "0x" : "0x1";
    var env = exports.generateDefaultTestEnv();
    var expect = [exports.generateDefaultTestExpect({ "0x": ohex })];
    var pre = exports.generateDefaultTestPre(code);
    var transaction = exports.generateDefaultTransaction();
    return exports.generateTestFiller(name, env, expect, pre, transaction);
};
exports.generateDefaultTestEnv = function () {
    return {
        currentCoinbase: "2adc25665018aa1fe0e6bc666dac8fc2697ff9ba",
        currentDifficulty: "0x020000",
        currentGasLimit: "0x7fffffffffffffff",
        currentNumber: "1",
        currentTimestamp: "1000",
        previousHash: "5e20a0453cecd065ea59c37ac63e079ee08998b6045136a8ce6635c7912ec0b6"
    };
};
exports.generateDefaultTestPre = function (code) {
    return {
        "095e7baea6a6c7c4c2dfeb977efac326af552d87": {
            "balance": "0",
            "code": code,
            "nonce": "0",
            "storage": {}
        },
        "a94f5374fce5edbc8e2a8697c15331677e6ebf0b": {
            "balance": "1000000000000000000000000000000",
            "code": "",
            "nonce": "0",
            "storage": {}
        }
    };
};
exports.generateDefaultTestExpect = function (storage) {
    return {
        indexes: {
            "data": -1,
            "gas": -1,
            "value": -1
        },
        network: [
            "Homestead"
        ],
        result: {
            "095e7baea6a6c7c4c2dfeb977efac326af552d87": {
                "storage": storage
            }
        }
    };
};
exports.generateDefaultTransaction = function () {
    return {
        data: [
            '0xf8a8fd6d'
        ],
        gasLimit: [
            "35000000"
        ],
        gasPrice: "1",
        nonce: "0",
        secretKey: "45a915e4d060149eb4365960e6a7a45f334393093061116b197e3240065ff2d8",
        to: "095e7baea6a6c7c4c2dfeb977efac326af552d87",
        value: [
            "0"
        ]
    };
};
exports.generateTestFiller = function (name, env, expect, pre, transaction) {
    var obj = {};
    obj[name] = {
        env: env,
        expect: expect,
        pre: pre,
        transaction: transaction
    };
    var validator = new ZSchema();
    var valid = validator.validate(obj, schema);
    if (!valid) {
        console.error(JSON.stringify(obj, null, '\t'));
        throw new Error("Failed to validate filler file against json-schema. Errors: " + JSON.stringify(validator.getLastErrors(), null, '\t'));
    }
    return obj;
};
