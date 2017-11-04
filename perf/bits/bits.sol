pragma solidity ^0.4.16;
pragma experimental "v0.5.0";
pragma experimental "ABIEncoderV2";

import {Bits} from "../../src/bits/Bits.sol";
import {STLPerf} from "../STLPerf.sol";


contract BitsPerf is STLPerf {
    using Bits for uint;
}


contract PerfBitsSetBit is BitsPerf {
    uint public res;

    function perf() public payable returns (uint) {
        uint n = 1;
        uint gasPre = msg.gas;
        var res_ = n.setBit(66);
        uint gasPost = msg.gas;
        res = res_;
        return gasPre - gasPost;
    }
}


contract PerfBitsClearBit is BitsPerf {
    uint public res;

    function perf() public payable returns (uint) {
        uint n = 1;
        uint gasPre = msg.gas;
        var res_ = n.clearBit(66);
        uint gasPost = msg.gas;
        res = res_;
        return gasPre - gasPost;
    }
}


contract PerfBitsToggleBit is BitsPerf {
    uint public res;

    function perf() public payable returns (uint) {
        uint n = 1;
        uint gasPre = msg.gas;
        var res_ = n.toggleBit(66);
        uint gasPost = msg.gas;
        res = res_;
        return gasPre - gasPost;
    }
}


contract PerfBitsBit is BitsPerf {
    uint public res;

    function perf() public payable returns (uint) {
        uint n = 1;
        uint gasPre = msg.gas;
        var res_ = n.bit(66);
        uint gasPost = msg.gas;
        res = res_;
        return gasPre - gasPost;
    }
}


contract PerfBitsBitSet is BitsPerf {
    bool public res;

    function perf() public payable returns (uint) {
        uint n = 1;
        uint gasPre = msg.gas;
        var res_ = n.bitSet(66);
        uint gasPost = msg.gas;
        res = res_;
        return gasPre - gasPost;
    }
}


contract PerfBitsBitEqual is BitsPerf {
    bool public res;

    function perf() public payable returns (uint) {
        uint n = 1;
        uint gasPre = msg.gas;
        var res_ = n.bitEqual(5, 66);
        uint gasPost = msg.gas;
        res = res_;
        return gasPre - gasPost;
    }
}


contract PerfBitsBitNot is BitsPerf {
    uint public res;

    function perf() public payable returns (uint) {
        uint n = 1;
        uint gasPre = msg.gas;
        var res_ = n.bitNot(66);
        uint gasPost = msg.gas;
        res = res_;
        return gasPre - gasPost;
    }
}


contract PerfBitsBitAnd is BitsPerf {
    uint public res;

    function perf() public payable returns (uint) {
        uint n = 1;
        uint gasPre = msg.gas;
        var res_ = n.bitAnd(0, 66);
        uint gasPost = msg.gas;
        res = res_;
        return gasPre - gasPost;
    }
}


contract PerfBitsBitOr is BitsPerf {
    uint public res;

    function perf() public payable returns (uint) {
        uint n = 1;
        uint gasPre = msg.gas;
        var res_ = n.bitOr(0, 66);
        uint gasPost = msg.gas;
        res = res_;
        return gasPre - gasPost;
    }
}


contract PerfBitsBitXor is BitsPerf {
    uint public res;

    function perf() public payable returns (uint) {
        uint n = 1;
        uint gasPre = msg.gas;
        var res_ = n.bitXor(0, 66);
        uint gasPost = msg.gas;
        res = res_;
        return gasPre - gasPost;
    }
}


contract PerfBitsBits is BitsPerf {
    uint public res;

    function perf() public payable returns (uint) {
        uint n = 1;
        uint gasPre = msg.gas;
        var res_ = n.bits(5, 66);
        uint gasPost = msg.gas;
        res = res_;
        return gasPre - gasPost;
    }
}


contract PerfBitsHighestBitSetLow is BitsPerf {
    uint public res;

    function perf() public payable returns (uint) {
        uint n = 1;
        uint gasPre = msg.gas;
        var res_ = n.highestBitSet();
        uint gasPost = msg.gas;
        res = res_;
        return gasPre - gasPost;
    }
}


contract PerfBitsHighestBitSetHigh is BitsPerf {
    uint public res;

    function perf() public payable returns (uint) {
        uint n = uint(1) << uint(255);
        uint gasPre = msg.gas;
        var res_ = n.highestBitSet();
        uint gasPost = msg.gas;
        res = res_;
        return gasPre - gasPost;
    }
}


contract PerfBitsLowestBitSetLow is BitsPerf {
    uint public res;

    function perf() public payable returns (uint) {
        uint n = 1;
        uint gasPre = msg.gas;
        var res_ = n.lowestBitSet();
        uint gasPost = msg.gas;
        res = res_;
        return gasPre - gasPost;
    }
}


contract PerfBitsLowestBitSetHigh is BitsPerf {
    uint public res;

    function perf() public payable returns (uint) {
        uint n = uint(1) << uint(255);
        uint gasPre = msg.gas;
        var res_ = n.lowestBitSet();
        uint gasPost = msg.gas;
        res = res_;
        return gasPre - gasPost;
    }
}
