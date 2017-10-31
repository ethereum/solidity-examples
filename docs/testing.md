## Tests

Tests are functor-styled single-method contracts extending the `STLTest` contract and implementing its `testImpl` method.

Tests are automatically compiled and run using a trivial test-runner written in javascript. It uses native `solc` and `evm` (go ethereum) to compile and execute the actual test code.

Tests that fail will throw. This is ensured by always using Solidity's `assert` function for test conditions.

1. One test function signature.
2. One contract per test, one function per contract.
3. Two possible results: throws or does not throw.

#### Example

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

### Naming

The xor test is named `TestBitsBitXor`:

1. `Test` is because it is a test contract, to distinguish it from other artifacts in the output directory. Tests always start with `Test`.
2. `Bits` is the name of the library contract being tested.
3. `BitXor` is the name of the function being tested.

Tests that are expected to throw must have the word `Throws` somewhere in the name. There can be other things in there as well, like further description of the test.

All test contracts for a given library is normally kept in the same solidity source file.

### Success and failure

In `STLTest.test()`, the test result is set to `true` prior to the execution of the actual test-code. This is done to detect if the function `throws` (although the `evm` also indicates that an illegal jump was made). The real point of this mechanism is to have uniformity over all tests (and a very simple way to interpret the return data in JS), which makes it easy to update.

1. If a test functor does not have the word `Throws` in the name, test passes if the return value is `true`.
2. If a test functor has the word `Throws` in the name, test passes if the return value is not `true`.

Note that the example test does not have the word `Throws` in the name, and is thus expected to not throw (i.e. none of the assertions is allowed to fail).
