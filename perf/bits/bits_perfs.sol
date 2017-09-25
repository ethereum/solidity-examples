pragma solidity ^0.4.16;
pragma experimental "v0.5.0";
pragma experimental "ABIEncoderV2";

import {Bits} from "../../src/bits/Bits.sol";
import {STLPerf} from "../STLPerf.sol";


contract PerfBitsSetBit is STLPerf {
    using Bits for uint;

    function perf() public payable returns (uint) {
        uint gasPre = msg.gas;
        uint(1).setBit(66);
        uint gasPost = msg.gas;
        return gasPre - gasPost;
    }
}


contract PerfBitsClearBit is STLPerf {
    using Bits for uint;

    function perf() public payable returns (uint) {
        uint gasPre = msg.gas;
        uint(1).clearBit(66);
        uint gasPost = msg.gas;
        return gasPre - gasPost;
    }
}


contract PerfBitsToggleBit is STLPerf {
    using Bits for uint;

    function perf() public payable returns (uint) {
        uint gasPre = msg.gas;
        uint(1).toggleBit(66);
        uint gasPost = msg.gas;
        return gasPre - gasPost;
    }
}


contract PerfBitsBit is STLPerf {
    using Bits for uint;

    function perf() public payable returns (uint) {
        uint gasPre = msg.gas;
        uint(1).bit(66);
        uint gasPost = msg.gas;
        return gasPre - gasPost;
    }
}


contract PerfBitsBitSet is STLPerf {
    using Bits for uint;

    function perf() public payable returns (uint) {
        uint gasPre = msg.gas;
        uint(1).bitSet(66);
        uint gasPost = msg.gas;
        return gasPre - gasPost;
    }
}


contract PerfBitsBitEqual is STLPerf {
    using Bits for uint;

    function perf() public payable returns (uint) {
        uint gasPre = msg.gas;
        uint(1).bitEqual(5, 66);
        uint gasPost = msg.gas;
        return gasPre - gasPost;
    }
}


contract PerfBitsBitAnd is STLPerf {
    using Bits for uint;

    function perf() public payable returns (uint) {
        uint gasPre = msg.gas;
        uint(1).bitAnd(0, 66);
        uint gasPost = msg.gas;
        return gasPre - gasPost;
    }
}


contract PerfBitsBitOr is STLPerf {
    using Bits for uint;

    function perf() public payable returns (uint) {
        uint gasPre = msg.gas;
        uint(1).bitOr(0, 66);
        uint gasPost = msg.gas;
        return gasPre - gasPost;
    }
}


contract PerfBitsBitXor is STLPerf {
    using Bits for uint;

    function perf() public payable returns (uint) {
        uint gasPre = msg.gas;
        uint(1).bitXor(0, 66);
        uint gasPost = msg.gas;
        return gasPre - gasPost;
    }
}


contract PerfBitsBits is STLPerf {
    using Bits for uint;

    function perf() public payable returns (uint) {
        uint gasPre = msg.gas;
        uint(1).bits(5, 66);
        uint gasPost = msg.gas;
        return gasPre - gasPost;
    }
}


contract PerfBitsHighestBitSetLow is STLPerf {
    using Bits for uint;

    function perf() public payable returns (uint) {
        uint gasPre = msg.gas;
        uint(1).highestBitSet();
        uint gasPost = msg.gas;
        return gasPre - gasPost;
    }
}


contract PerfBitsHighestBitSetHigh is STLPerf {
    using Bits for uint;

    function perf() public payable returns (uint) {
        uint gasPre = msg.gas;
        (uint(1) << uint(255)).highestBitSet();
        uint gasPost = msg.gas;
        return gasPre - gasPost;
    }
}


contract PerfBitsLowestBitSetLow is STLPerf {
    using Bits for uint;

    function perf() public payable returns (uint) {
        uint gasPre = msg.gas;
        uint(1).lowestBitSet();
        uint gasPost = msg.gas;
        return gasPre - gasPost;
    }
}


contract PerfBitsLowestBitSetHigh is STLPerf {
    using Bits for uint;

    function perf() public payable returns (uint) {
        uint gasPre = msg.gas;
        (uint(1) << uint(255)).lowestBitSet();
        uint gasPost = msg.gas;
        return gasPre - gasPost;
    }
}
