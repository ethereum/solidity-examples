## Perf

The performance of a contract is measured by looking at its gas-usage. It is mostly used in a relative way, by comparing the gas cost before and after code (or the compiler, or the evm) has been changed.

Each performance test is a single-method contract which is run in the go-ethereum `evm`, but unlike tests, perf functors implements the `perf`-function directly.

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

### Absolute vs. relative results

Perf is not used primarily to check how much gas is spent when running a function; the main reason is to see how gas cost changes when there has been changes to the code, compiler, and runtime environment. This analysis is made possible by adding perf functions to all library functions, and using a system that computes and displays the difference if gas cost between code updates.

### Accuracy

The goal is to keep the perf result as close to the runtime gas-cost of the tested function as possible, but there will usually be a small difference. One reason is that part of the code may be optimized away unless some redundant code is added.

The goal is to minimize these deviations, but **there are no guaranteed bounds**.