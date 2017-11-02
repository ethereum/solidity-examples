pragma solidity ^0.4.16;
pragma experimental "v0.5.0";
pragma experimental "ABIEncoderV2";

import {Data} from "../../src/patricia_tree/Data.sol";
import {STLPerf} from "../STLPerf.sol";


contract PatriciaTreeDataPerf is STLPerf {
    using Data for Data.Node;
    using Data for Data.Edge;
    using Data for Data.Label;

    uint internal constant MAX_LENGTH = 256;
    uint internal constant UINT256_ZEROES = 0;
    uint internal constant UINT256_ONES = ~uint(0);

    bytes32 internal constant B32_ZEROES = bytes32(UINT256_ZEROES);
    bytes32 internal constant B32_ONES = bytes32(UINT256_ONES);
}


contract PerfPatriciaTreeDataChopFirstBit is PatriciaTreeDataPerf {
    function perf() public payable returns (uint) {
        var lbl = Data.Label(0, 1);
        uint gasPre = msg.gas;
        lbl.chopFirstBit();
        uint gasPost = msg.gas;
        return gasPre - gasPost;
    }
}


contract PerfPatriciaTreeDataRemovePrefix is PatriciaTreeDataPerf {
    function perf() public payable returns (uint) {
        var lbl = Data.Label(0, 5);
        uint gasPre = msg.gas;
        lbl.removePrefix(5);
        uint gasPost = msg.gas;
        return gasPre - gasPost;
    }
}


contract PerfPatriciaTreeDataCommonPrefixLengthZero is PatriciaTreeDataPerf {
    function perf() public payable returns (uint) {
        var lbl = Data.Label(B32_ZEROES, 0);
        uint gasPre = msg.gas;
        lbl.commonPrefix(lbl);
        uint gasPost = msg.gas;
        return gasPre - gasPost;
    }
}


contract PerfPatriciaTreeDataCommonPrefixNoMatch is PatriciaTreeDataPerf {
    function perf() public payable returns (uint) {
        var lbl = Data.Label(B32_ZEROES, 256);
        var lbl2 = Data.Label(B32_ONES, 256);
        uint gasPre = msg.gas;
        lbl.commonPrefix(lbl2);
        uint gasPost = msg.gas;
        return gasPre - gasPost;
    }
}


contract PerfPatriciaTreeDataCommonPrefixFullMatch is PatriciaTreeDataPerf {
    function perf() public payable returns (uint) {
        var lbl = Data.Label(B32_ZEROES, 256);
        uint gasPre = msg.gas;
        lbl.commonPrefix(lbl);
        uint gasPost = msg.gas;
        return gasPre - gasPost;
    }
}


contract PerfPatriciaTreeDataSplitAtPositionZero is PatriciaTreeDataPerf {
    function perf() public payable returns (uint) {
        var lbl = Data.Label(B32_ZEROES, 256);
        uint gasPre = msg.gas;
        lbl.splitAt(0);
        uint gasPost = msg.gas;
        return gasPre - gasPost;
    }
}


contract PerfPatriciaTreeDataSplitAt is PatriciaTreeDataPerf {
    function perf() public payable returns (uint) {
        var lbl = Data.Label(B32_ZEROES, 256);
        uint gasPre = msg.gas;
        lbl.splitAt(55);
        uint gasPost = msg.gas;
        return gasPre - gasPost;
    }
}


contract PerfPatriciaTreeDataSplitCommonPrefix is PatriciaTreeDataPerf {
    function perf() public payable returns (uint) {
        var lbl = Data.Label(B32_ZEROES, 256);
        var lbl2 = Data.Label(0x1111, 256);
        uint gasPre = msg.gas;
        lbl.splitCommonPrefix(lbl2);
        uint gasPost = msg.gas;
        return gasPre - gasPost;
    }
}