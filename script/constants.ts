import path = require('path');

// Paths.
export const ROOT_PATH = path.join(__dirname, '..');
export const SRC_PATH = path.join(ROOT_PATH, 'src');
export const LOGS_PATH = path.join(ROOT_PATH, 'logs');
export const BIN_OUTPUT_PATH = path.join(ROOT_PATH, 'bin_output');

export const TEST_CONTRACT_PATH = path.join(ROOT_PATH, 'test');
export const TEST_LOGS_PATH = path.join(LOGS_PATH, 'test');

export const PERF_CONTRACT_PATH = path.join(ROOT_PATH, 'perf');
export const PERF_LOGS_PATH = path.join(LOGS_PATH, 'perf');

export const EXAMPLES_PATH = path.join(ROOT_PATH, 'examples');

export const DATA_PATH = path.join(ROOT_PATH, 'data');

export const DOCS_PATH = path.join(ROOT_PATH, 'docs');
export const PACKAGE_DOCS_PATH = path.join(DOCS_PATH, 'packages');

// Function hashes.
export const TEST_FUN_HASH = 'f8a8fd6d';
export const PERF_FUN_HASH = '1c4af786';

// Constant file IDs.
export const DATA_FILE = path.join(DATA_PATH, 'data.json');
export const RESULTS_NAME_OPTIMIZED = "results_optimized.json";
export const RESULTS_NAME_UNOPTIMIZED = "results_unoptimized.json";
