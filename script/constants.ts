import path = require('path');

// Paths.
export const ROOT_PATH = path.join(__dirname, '..');
export const SRC_PATH = path.join(ROOT_PATH, 'src');
export const LOGS = path.join(ROOT_PATH, 'logs');
export const BIN_OUTPUT = path.join(ROOT_PATH, 'bin_output');

export const TEST_CONTRACT_PATH = path.join(ROOT_PATH, 'test');
export const TEST_LOGS = path.join(LOGS, 'test');

export const PERF_CONTRACT_PATH = path.join(ROOT_PATH, 'perf');
export const PERF_LOGS = path.join(LOGS, 'perf');

export const EXAMPLES_FOLDER = path.join(ROOT_PATH, 'examples');

export const DOCS_FOLDER = path.join(ROOT_PATH, 'docs');
export const PACKAGE_DOCS_FOLDER = path.join(DOCS_FOLDER, 'packages');
export const PACKAGE_DOCS_DATA_FOLDER = path.join(PACKAGE_DOCS_FOLDER, 'data');

// Function hashes.
export const TEST_FUN_HASH = 'f8a8fd6d';
export const PERF_FUN_HASH = '1c4af786';

// Constant file IDs.
export const RESULTS_NAME_OPTIMIZED = "results_optimized.json";
export const RESULTS_NAME_UNOPTIMIZED = "results_unoptimized.json";

export const UNITS: Array<[string, string, string]> = [
    ['bits', 'Bits', 'bits'],
    ['bytes', 'Bytes', 'bytes'],
    ['math', 'Math', 'math'],
    ['patricia_tree', 'PatriciaTree', 'patricia_tree'],
    ['strings', 'Strings', 'strings'],
    ['unsafe', 'Memory', 'memory']
];

export const UNITS_EXTENDED: Array<[string, string, string]> = [
    ['math', '', 'math_consistency']
];
