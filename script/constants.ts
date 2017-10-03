import path = require('path');

// Paths.
export const ROOT_PATH = path.join(__dirname, '..');
export const LOGS = path.join(ROOT_PATH, 'logs');

export const TEST_CONTRACT_PATH = path.join(ROOT_PATH, 'test');
export const TEST_LOGS = path.join(LOGS, 'test');
export const TEST_BIN = path.join(ROOT_PATH, 'test_bin');

export const PERF_CONTRACT_PATH = path.join(ROOT_PATH, 'perf');
export const PERF_LOGS = path.join(LOGS, 'perf');
export const PERF_BIN = path.join(ROOT_PATH, 'perf_bin');

// Function hashes.
export const TEST_FUN_HASH = 'f8a8fd6d';
export const PERF_FUN_HASH = '1c4af786';

// Constant file IDs.
export const RESULTS_NAME_OPTIMIZED = "results_optimized.json";
export const RESULTS_NAME_UNOPTIMIZED = "results_unoptimized.json";

export const UNITS: Array<[string, string]> = [
    ['bits', 'bits'],
    ['bytes', 'bytes'],
    ['math', 'math'],
    ['patricia_tree', 'patricia_tree'],
    ['strings', 'strings'],
    ['unsafe', 'memory']
];

export const UNITS_EXTENDED: Array<[string, string]> = [
    ['math', 'math_consistency']
];
