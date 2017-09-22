
import {generate as generateBits} from '../test/bits/generators';
import {generate as generateBytes} from '../test/bytes/generators';
import {generate as generatePatriciaTree} from '../test/patricia_tree/generators';
import {generate as generateUnsafe} from '../test/unsafe/generators';

import path = require('path');

// Paths
export const ROOT_PATH = path.join(__dirname, '..');

export const TEST_CONTRACT_PATH = path.join(ROOT_PATH, 'test');
export const TESTETH_PATH = path.join(ROOT_PATH, 'testeth');
export const TEST_BIN = path.join(TESTETH_PATH, 'test_bin');
export const TESTS_PATH = path.join(TESTETH_PATH, 'GeneralStateTests', 'stSolidityTest');
export const FILLERS_PATH = path.join(TESTETH_PATH, 'src', 'GeneralStateTestsFiller', 'stSolidityTest');

export const PERF_CONTRACT_PATH = path.join(ROOT_PATH, 'perf');
export const LOGS = path.join(ROOT_PATH, 'logs');
export const PERF_LOGS = path.join(LOGS, 'perf');

export const PERF_BIN = path.join(ROOT_PATH, 'perf_bin');

// Function hashes
export const TEST_FUN_HASH = 'f8a8fd6d';
export const PERF_FUN_HASH = '1c4af786';

export const UNITS: Array<[string, string, () => Object]> = [
    ['bits', 'bits', generateBits],
    ['bytes', 'bytes', generateBytes],
    ['patricia_tree', 'patricia_tree', generatePatriciaTree],
    ['unsafe', 'memory', generateUnsafe]
];