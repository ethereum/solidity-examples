# Solidity Examples

## Standard library (draft)

Temporary storage for a standard library of Solidity contracts.

This is a draft document.

### Purpose

The standard library should provide Solidity libraries / functions for performing common tasks, such as working with strings, bits, and other common types, and for working with Ethereum and Ethereum related technologies, like for example Patricia Tries and RLP.

### Quality Assurance

Routines for making sure that code meets the required standards when it comes to:

1. Integrity
2. Style
3. Docs

#### Testing

npm test. Requires `solc` and `testeth` to be installed and added to $path. The test script compiles all contracts, auto-generates fillers and puts them in a directory with a layout similar to that of ethereum/tests - although it only contains `src/GeneralStateTestsFiller/stSolidityTest`; that directory is then used as root for the `testeth` tests.

#### Style

The standard library should serve as an (or perhaps *the*) example of strict, idiomatic Solidity. This means all code is written following the style guide, as well as the practices and patterns laid out at solidity.readthedocs.org. It also means utilizing the language features and compiler to the greatest extent possible. This way of working would not just be a way to ensure quality and readability, but also help drive the development of the style, practices and patterns themselves.

#### Documentation

Briefly: the documentation should specify - in a very clear and concise a way - what the contract of the library/function is, the interfaces / function signatures should reflect that, and the functions should (obviously) behave as described.

#### Manual review

Code should be reviewed by at least one person other then the writer.

#### Issues and feedback

Github issues and gitter solidity channel.

### Ranking / categorization of contracts

The QA only really applies to code that is meant to be used in production, but the library will also include code that has not yet reached that level.

Node.js has a system of categorizing libraries, experimental, stable, deprecated, and so forth. This library should have something similar.


### Test layout

Tests are single-method contracts, extending the `STLTest` contract, and implementing its `testImpl` method.

Tests are automatically compiled, and a filler is generated using the compiler artifacts.

`testeth` is run using all available protocols, and includes fillers both for optimized and unoptimized code.

Basic test is one that either throws or not. If it is expected to throw, it must have `Throws` somewhere in the test name, otherwise it is assumed that the test should succeed.

##### Example

This is the `STLTest` contract.

```
contract STLTest {

    bool ret;

    function test() {
        ret = true;
        testImpl();
    }

    function testImpl() internal;

}
```

The test for `Bits.bitXor(uint bitfield, uint8 index)` looks like this:

```
contract TestBitsBitXor is BitsTest {
    function testImpl() internal {
        for (uint8 i = 0; i < 12; i++) {
            assert(ONES.bitXor(ONES, i*20) == 0);
            assert(ONES.bitXor(ZERO, i*20) == 1);
            assert(ZERO.bitXor(ONES, i*20) == 1);
            assert(ZERO.bitXor(ZERO, i*20) == 0);
        }
    }
}
```

It loops over the tested `uint`s and makes sure XOR works as expected.

The xor test is named `TestBitsBitXor`:

1. `Test` is because it is a test contract, to distinguish it from other artifacts in the output directory. Tests always start with `Test`.
2. `Bits` is the name of the library contract being tested.
3. `BitXor` is the name of the function being tested.

There can be other things in there as well, like further description of the test. Usually, all test contracts for a given library is in the same solidity source file.

When generated, the full name of this test will be the test name + `Opt` or `Unopt` depending on whether or not the compiler was set to optimize, and finally it ends with `Filler`.

The filler for the above test, with optimizer enabled, is `TestBitsBitXorOpt`, and the filler file would be named: `TestBitsBitXorOptFiller.json`. Here is the generated filler (as of 2017-09-11).

```
{
	"TestBitsBitXorOpt": {
		"env": {
			"currentCoinbase": "2adc25665018aa1fe0e6bc666dac8fc2697ff9ba",
			"currentDifficulty": "0x020000",
			"currentGasLimit": "0x7fffffffffffffff",
			"currentNumber": "1",
			"currentTimestamp": "1000",
			"previousHash": "5e20a0453cecd065ea59c37ac63e079ee08998b6045136a8ce6635c7912ec0b6"
		},
		"expect": [
			{
				"indexes": {
					"data": -1,
					"gas": -1,
					"value": -1
				},
				"network": [
					"ALL"
				],
				"result": {
					"095e7baea6a6c7c4c2dfeb977efac326af552d87": {
						"storage": {
							"0x": "0x1"
						}
					}
				}
			}
		],
		"pre": {
			"095e7baea6a6c7c4c2dfeb977efac326af552d87": {
				"balance": "0",
				"code": "0x60606040526000357c0100000000000000000000000000000000000000000000000000000000900463ffffffff168063f8a8fd6d1461003d57600080fd5b341561004857600080fd5b610050610052565b005b60016000806101000a81548160ff021916908315150217905550610074610076565b565b60008090505b600c8160ff1610156101b15760006100e27fffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff601484027fffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff6101b49092919063ffffffff16565b60ff161415156100ee57fe5b60016101296000601484027fffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff6101b49092919063ffffffff16565b60ff1614151561013557fe5b60016101707fffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff6014840260006101b49092919063ffffffff16565b60ff1614151561017c57fe5b600061019860006014840260006101b49092919063ffffffff16565b60ff161415156101a457fe5b808060010191505061007c565b50565b600060018260ff16849060020a90041660018360ff16869060020a90041618905093925050505600a165627a7a723058206b0a58ef09330af9646f777792dbd59d5f1e8e6858193743f228d317ae5386d60029",
				"nonce": "0",
				"storage": {}
			},
			"a94f5374fce5edbc8e2a8697c15331677e6ebf0b": {
				"balance": "1000000000000000000000000000000",
				"code": "",
				"nonce": "0",
				"storage": {}
			}
		},
		"transaction": {
			"data": [
				"0xf8a8fd6d"
			],
			"gasLimit": [
				"35000000"
			],
			"gasPrice": "1",
			"nonce": "0",
			"secretKey": "45a915e4d060149eb4365960e6a7a45f334393093061116b197e3240065ff2d8",
			"to": "095e7baea6a6c7c4c2dfeb977efac326af552d87",
			"value": [
				"0"
			]
		}
	}
}
```

Note that this test does not have the word `Throws` in the name, and is thus not expected to throw. This means `ret == true`, so it is expected that `storage[0x] = 0x1`. Otherwise, it would have expected it to be `0x`.

##### testeth fillers

Fillers has a name, and four different principal parts:

1. `env` - Defines the execution environment.
2. `pre` - Defines the pre-state. In default tests, STL uses a contract account for putting the code in, and an account to transact from.
3. `transaction` - The transaction data. In default tests, this just has the function id for `test()` as data, along with some account info.
4. `expect` - How the state is expected to be after the transaction has been executed. In default tests, this is a simple check of storage address `0x`.

The STL test-framework makes it possible to modify the filler any way needed, by making it possible to set custom filler generators for individual test cases. This is used in some Patricia Tree tests for example. If no custom generator is set, it defaults to the standard (throws or does not throw) template, which looks the exact same for all tests except for the test name and code.

More about testeth can be found at http://ethereum-tests.readthedocs.io/en/latest/.

## Packages

These are the different packages.

[bits](docs/packages/bits.md)

[bytes](docs/packages/bytes.md)

[patricia_tree](docs/packages/patricia_tree.md)

[rlp](docs/packages/rlp.md)

[strings](docs/packages/strings.md)

[unsafe](docs/packages/unsafe.md)