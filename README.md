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

npm test. Requires `solc` and `evm` (go ethereum) to be installed and added to $path. Test code is written in Solidity, and is executed directly in the evm.

#### Style

The standard library should serve as an (or perhaps *the*) example of strict, idiomatic Solidity. This means all code is written following the style guide, as well as the practices and patterns laid out at solidity.readthedocs.org. It also means utilizing the language features and compiler to the greatest extent possible. This way of working would not just be a way to ensure quality and readability, but also help drive the development of the style, practices and patterns themselves.

#### Documentation

Briefly: the documentation should specify - in a very clear and concise a way - what the contract of the library/function is, the interfaces / function signatures should reflect that, and the functions should (obviously) behave as described.

#### Manual review

Code should be reviewed by at least one person other then the writer.

#### Issues and feedback

Github issues and gitter solidity channel.

### Ranking / categorization of contracts

The QA only really applies to code that is meant to be used in production, but the library will also include code that has not reached that level.

Node.js has a system of categorizing libraries, experimental, stable, deprecated, and so forth. This library should have something similar.


### Test layout

Tests are functor-styled single-method contracts extending the `STLTest` contract and implementing its `testImpl` method.

Tests are automatically compiled and run using a trivial test-runner written in javascript. It uses native `solc` and `evm` (go ethereum) to compile and execute the actual test code.

Tests that fail will throw. This is ensured by always using Solidity's `assert` function for test conditions.

1. One test function signature.
2. One contract per test, one function per contract.
3. Two possible results: throws or does not throw.

##### Example

This is the `STLTest` contract; its `test` method is the basis for all tests.

```
contract STLTest {

    function test() public payable returns (bool ret) {
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

`BitsTest` is a simple (abstract) contract that extends `STLTest` and includes some constants and bindings that are useful for multiple tests throughout the suite (this pattern is used in most suites):

```
contract BitsTest is STLTest {
    using Bits for uint;

    uint constant ZERO = uint(0);
    uint constant ONE = uint(1);
    uint constant ONES = uint(~0);
}
```

#### Naming

The xor test is named `TestBitsBitXor`:

1. `Test` is because it is a test contract, to distinguish it from other artifacts in the output directory. Tests always start with `Test`.
2. `Bits` is the name of the library contract being tested.
3. `BitXor` is the name of the function being tested.

Tests that are expected to throw must have the word `Throws` somewhere in the name. There can be other things in there as well, like further description of the test.

All test contracts for a given library is normally kept in the same solidity source file.

#### Success and failure

In `STLTest.test()`, the test result is set to `true` prior to the execution of the actual test-code. This is done to detect if the function `throws` (although the `evm` also indicates that an illegal jump was made). The real point of this mechanism is to have uniformity over all tests (and a very simple way to interpret the return data in JS), which makes it easy to update.

1. If a test functor does not have the word `Throws` in the name, test passes if the return value is `true`.
2. If a test functor has the word `Throws` in the name, test passes if the return value is not `true`.

Note that the example test does not have the word `Throws` in the name, and is thus expected to not throw (i.e. none of the assertions is allowed to fail).

## Perf

The performance of a contract is measured by looking at its gas-usage. It is mostly used in a relative way, by comparing the gas cost before and after code (or the compiler, or the evm) has been changed.

The perf system is similar to the tests in that each perf is a single-method contract which is run in the go-ethereum `evm`, but unlike tests, perf functors implements the `perf`-function directly.

The `perf` function returns the gas spent during execution of the tested function. This is implemented by storing the remaining gas before and after the function is executed, and then taking the difference.

The reason that perf metering is done manually in every function is so that the implementor can exclude the staging part of the code (preparing variables & data) from the code that should be metered.

#### Example

This is the `STLPerf` contract; its `perf` method is the basis for all perf:

```
contract STLPerf {
    function perf() public payable returns (uint);
}
```

This is an example of a perf functor. It measures the gas cost when the `Bytes.equals` function can early out because the lengths of the two `bytes` are not the same:

```
contract PerfBytesEqualsDifferentLengthFail is BytesPerf {
    function perf() public payable returns (uint) {
        bytes memory bts1 = new bytes(0);
        bytes memory bts2 = new bytes(1);
        uint gasPre = msg.gas;
        Bytes.equals(bts1, bts2);
        uint gasPost = msg.gas;
        return gasPre - gasPost;
    }
}
```

## Packages

These are the different packages.

[bits](docs/packages/bits.md)

[bytes](docs/packages/bytes.md)

[math](docs/packages/math.md)

[patricia_tree](docs/packages/patricia_tree.md)

[rlp](docs/packages/rlp.md)

[strings](docs/packages/strings.md)

[token](docs/packages/tokens.md)

[unsafe](docs/packages/unsafe.md)

On top of the package documentation there are also documentation in the contracts themselves, and a number of code examples in the `examples` folder.