pragma solidity ^0.4.16;
pragma experimental "v0.5.0";
pragma experimental "ABIEncoderV2";

import {Bits} from "../../src/bits/Bits.sol";
import {STLPerf} from "../STLPerf.sol";


contract BitsPerf is STLPerf {
    using Bits for uint;
}


contract PerfBitsSetBit is BitsPerf {
    function perf() public payable returns (uint) {
        uint gasPre = msg.gas;
        uint(1).setBit(66);
        uint gasPost = msg.gas;
        return gasPre - gasPost;
    }
}


contract PerfBitsClearBit is BitsPerf {
    function perf() public payable returns (uint) {
        uint gasPre = msg.gas;
        uint(1).clearBit(66);
        uint gasPost = msg.gas;
        return gasPre - gasPost;
    }
}


contract PerfBitsToggleBit is BitsPerf {
    function perf() public payable returns (uint) {
        uint gasPre = msg.gas;
        uint(1).toggleBit(66);
        uint gasPost = msg.gas;
        return gasPre - gasPost;
    }
}


contract PerfBitsBit is BitsPerf {
    function perf() public payable returns (uint) {
        uint gasPre = msg.gas;
        uint(1).bit(66);
        uint gasPost = msg.gas;
        return gasPre - gasPost;
    }
}


contract PerfBitsBitSet is BitsPerf {
    function perf() public payable returns (uint) {
        uint gasPre = msg.gas;
        uint(1).bitSet(66);
        uint gasPost = msg.gas;
        return gasPre - gasPost;
    }
}


contract PerfBitsBitEqual is BitsPerf {
    function perf() public payable returns (uint) {
        uint gasPre = msg.gas;
        uint(1).bitEqual(5, 66);
        uint gasPost = msg.gas;
        return gasPre - gasPost;
    }
}


contract PerfBitsBitNot is BitsPerf {
    function perf() public payable returns (uint) {
        uint gasPre = msg.gas;
        uint(1).bitNot(66);
        uint gasPost = msg.gas;
        return gasPre - gasPost;
    }
}


contract PerfBitsBitAnd is BitsPerf {
    function perf() public payable returns (uint) {
        uint gasPre = msg.gas;
        uint(1).bitAnd(0, 66);
        uint gasPost = msg.gas;
        return gasPre - gasPost;
    }
}


contract PerfBitsBitOr is BitsPerf {
    function perf() public payable returns (uint) {
        uint gasPre = msg.gas;
        uint(1).bitOr(0, 66);
        uint gasPost = msg.gas;
        return gasPre - gasPost;
    }
}


contract PerfBitsBitXor is BitsPerf {
    function perf() public payable returns (uint) {
        uint gasPre = msg.gas;
        uint(1).bitXor(0, 66);
        uint gasPost = msg.gas;
        return gasPre - gasPost;
    }
}


contract PerfBitsBits is BitsPerf {
    function perf() public payable returns (uint) {
        uint gasPre = msg.gas;
        uint(1).bits(5, 66);
        uint gasPost = msg.gas;
        return gasPre - gasPost;
    }
}


contract PerfBitsHighestBitSetLow is BitsPerf {
    function perf() public payable returns (uint) {
        uint gasPre = msg.gas;
        uint(1).highestBitSet();
        uint gasPost = msg.gas;
        return gasPre - gasPost;
    }
}


contract PerfBitsHighestBitSetHigh is BitsPerf {
    function perf() public payable returns (uint) {
        uint gasPre = msg.gas;
        (uint(1) << uint(255)).highestBitSet();
        uint gasPost = msg.gas;
        return gasPre - gasPost;
    }
}


contract PerfBitsLowestBitSetLow is BitsPerf {
    function perf() public payable returns (uint) {
        uint gasPre = msg.gas;
        uint(1).lowestBitSet();
        uint gasPost = msg.gas;
        return gasPre - gasPost;
    }
}


contract PerfBitsLowestBitSetHigh is BitsPerf {
    function perf() public payable returns (uint) {
        uint gasPre = msg.gas;
        (uint(1) << uint(255)).lowestBitSet();
        uint gasPost = msg.gas;
        return gasPre - gasPost;
    }
}
