"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
var path = require("path");
// Paths
exports.ROOT_PATH = path.join(__dirname, '..');
exports.LOGS = path.join(exports.ROOT_PATH, 'logs');
exports.TEST_CONTRACT_PATH = path.join(exports.ROOT_PATH, 'test');
exports.TEST_BIN = path.join(exports.ROOT_PATH, 'test_bin');
exports.PERF_CONTRACT_PATH = path.join(exports.ROOT_PATH, 'perf');
exports.PERF_LOGS = path.join(exports.LOGS, 'perf');
exports.PERF_BIN = path.join(exports.ROOT_PATH, 'perf_bin');
// Function hashes
exports.TEST_FUN_HASH = 'f8a8fd6d';
exports.PERF_FUN_HASH = '1c4af786';
exports.UNITS = [
    ['bits', 'bits'],
    ['bytes', 'bytes'],
    ['patricia_tree', 'patricia_tree'],
    ['unsafe', 'memory']
];
