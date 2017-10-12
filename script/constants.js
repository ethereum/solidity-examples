"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
var path = require("path");
// Paths.
exports.ROOT_PATH = path.join(__dirname, '..');
exports.LOGS = path.join(exports.ROOT_PATH, 'logs');
exports.TEST_CONTRACT_PATH = path.join(exports.ROOT_PATH, 'test');
exports.TEST_LOGS = path.join(exports.LOGS, 'test');
exports.TEST_BIN = path.join(exports.ROOT_PATH, 'test_bin');
exports.PERF_CONTRACT_PATH = path.join(exports.ROOT_PATH, 'perf');
exports.PERF_LOGS = path.join(exports.LOGS, 'perf');
exports.PERF_BIN = path.join(exports.ROOT_PATH, 'perf_bin');
exports.EXAMPLES_FOLDER = path.join(exports.ROOT_PATH, 'examples');
exports.DOCS_FOLDER = path.join(exports.ROOT_PATH, 'docs');
exports.PACKAGE_DOCS_FOLDER = path.join(exports.DOCS_FOLDER, 'packages');
exports.PACKAGE_DOCS_DATA_FOLDER = path.join(exports.PACKAGE_DOCS_FOLDER, 'data');
// Function hashes.
exports.TEST_FUN_HASH = 'f8a8fd6d';
exports.PERF_FUN_HASH = '1c4af786';
// Constant file IDs.
exports.RESULTS_NAME_OPTIMIZED = "results_optimized.json";
exports.RESULTS_NAME_UNOPTIMIZED = "results_unoptimized.json";
exports.UNITS = [
    ['bits', 'bits'],
    ['bytes', 'bytes'],
    ['math', 'math'],
    ['patricia_tree', 'patricia_tree'],
    ['strings', 'strings'],
    ['unsafe', 'memory']
];
exports.UNITS_EXTENDED = [
    ['math', 'math_consistency']
];
