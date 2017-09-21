pragma solidity ^0.4.15;

import {Bits} from "../../src/bits/Bits.sol";
import {STLPerf} from "../STLPerf.sol";

contract BitsPerf is STLPerf {

    uint constant ZERO = uint(0);
    uint constant ONE = uint(1);
    uint constant ONES = uint(~0);

    using Bits for uint;
}


contract PerfBitsBitAnd is BitsPerf {
    function perfImpl() internal {
        ONE.bitAnd(ZERO, 66);
    }
}


contract PerfBitsHighestBitSet is BitsPerf {
    function perfImpl() internal {
        ONE.highestBitSet();
    }
}


contract PerfBits is BitsPerf {
    function perfImpl() internal {

    }
}