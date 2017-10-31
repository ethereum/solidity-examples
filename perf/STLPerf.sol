pragma solidity ^0.4.16;
pragma experimental "v0.5.0";
pragma experimental "ABIEncoderV2";


// Extend for performance tests. Output of 'perf()' is the gas diff.
// If buildup is required before gauging, override 'perf()' and do
// gas reporting manually.
// If no buildup is needed, just extend 'prefImpl()'.
contract STLPerf {
    function perf() public payable returns (uint);
}