"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
var path = require("path");
// Paths.
exports.ROOT_PATH = path.join(__dirname, '..');
exports.SRC_PATH = path.join(exports.ROOT_PATH, 'src');
exports.LOGS_PATH = path.join(exports.ROOT_PATH, 'logs');
exports.BIN_OUTPUT_PATH = path.join(exports.ROOT_PATH, 'bin_output');
exports.TEST_CONTRACT_PATH = path.join(exports.ROOT_PATH, 'test');
exports.TEST_LOGS_PATH = path.join(exports.LOGS_PATH, 'test');
exports.PERF_CONTRACT_PATH = path.join(exports.ROOT_PATH, 'perf');
exports.PERF_LOGS_PATH = path.join(exports.LOGS_PATH, 'perf');
exports.EXAMPLES_PATH = path.join(exports.ROOT_PATH, 'examples');
exports.DATA_PATH = path.join(exports.ROOT_PATH, 'data');
exports.DOCS_PATH = path.join(exports.ROOT_PATH, 'docs');
exports.PACKAGE_DOCS_PATH = path.join(exports.DOCS_PATH, 'packages');
// Function hashes.
exports.TEST_FUN_HASH = 'f8a8fd6d';
exports.PERF_FUN_HASH = '1c4af786';
// Constant file IDs.
exports.DATA_FILE = path.join(exports.DATA_PATH, 'data.json');
exports.RESULTS_NAME_OPTIMIZED = "results_optimized.json";
exports.RESULTS_NAME_UNOPTIMIZED = "results_unoptimized.json";
