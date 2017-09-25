pragma solidity ^0.4.16;
pragma experimental "v0.5.0";
pragma experimental "ABIEncoderV2";

import {Bytes} from "../../src/bytes/Bytes.sol";
import {STLPerf} from "../STLPerf.sol";


// bytes memory bts1 = hex"aabbccddeeff8899aabbccddeeff8899aabbccddeeff8899";
// bytes memory bts2 = hex"aabbccddeeffaabbccddeeffaabbcc";

contract BytesPerf is STLPerf {
    using Bytes for bytes;
    using Bytes for bytes32;
}

contract PerfBytesEqualsOneWordSuccess is BytesPerf {
    function perf() public payable returns (uint) {
        bytes memory bts = new bytes(32);
        uint gasPre = msg.gas;
        Bytes.equals(bts, bts);
        uint gasPost = msg.gas;
        return gasPre - gasPost;
    }
}


contract PerfBytesEqualsTenWordsSuccess is BytesPerf {
    function perf() public payable returns (uint) {
        bytes memory bts = new bytes(320);
        uint gasPre = msg.gas;
        Bytes.equals(bts, bts);
        uint gasPost = msg.gas;
        return gasPre - gasPost;
    }
}


contract PerfBytesEqualsHalfWordSuccess is BytesPerf {
    function perf() public payable returns (uint) {
        bytes memory bts = new bytes(16);
        uint gasPre = msg.gas;
        Bytes.equals(bts, bts);
        uint gasPost = msg.gas;
        return gasPre - gasPost;
    }
}


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


contract PerfBytesEqualsOneWordFail is BytesPerf {
    function perf() public payable returns (uint) {
        bytes memory bts1 = new bytes(32);
        bytes memory bts2 = hex"aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa";
        uint gasPre = msg.gas;
        Bytes.equals(bts1, bts2);
        uint gasPost = msg.gas;
        return gasPre - gasPost;
    }
}


contract PerfBytesCopyOneWord is BytesPerf {
    function perf() public payable returns (uint) {
        bytes memory bts = new bytes(32);
        uint gasPre = msg.gas;
        bts.copy();
        uint gasPost = msg.gas;
        return gasPre - gasPost;
    }
}


contract PerfBytesCopyTenWords is BytesPerf {
    function perf() public payable returns (uint) {
        bytes memory bts = new bytes(320);
        uint gasPre = msg.gas;
        bts.copy();
        uint gasPost = msg.gas;
        return gasPre - gasPost;
    }
}


contract PerfBytesCopyEmpty is BytesPerf {
    function perf() public payable returns (uint) {
        bytes memory bts = new bytes(0);
        uint gasPre = msg.gas;
        bts.copy();
        uint gasPost = msg.gas;
        return gasPre - gasPost;
    }
}


contract PerfBytesCopyWithStartIndexOneWord is BytesPerf {
    function perf() public payable returns (uint) {
        bytes memory bts = new bytes(35);
        uint gasPre = msg.gas;
        bts.copy(3);
        uint gasPost = msg.gas;
        return gasPre - gasPost;
    }
}


contract PerfBytesCopyWithStartIndexAndLengthOneWord is BytesPerf {
    function perf() public payable returns (uint) {
        bytes memory bts = new bytes(35);
        uint gasPre = msg.gas;
        bts.copy(2, 32);
        uint gasPost = msg.gas;
        return gasPre - gasPost;
    }
}


contract PerfBytesConcatTwoWords is BytesPerf {
    function perf() public payable returns (uint) {
        bytes memory bts = new bytes(32);
        uint gasPre = msg.gas;
        bts.concat(bts);
        uint gasPost = msg.gas;
        return gasPre - gasPost;
    }
}


contract PerfBytesConcatTenWords is BytesPerf {
    function perf() public payable returns (uint) {
        bytes memory bts = new bytes(160);
        uint gasPre = msg.gas;
        bts.concat(bts);
        uint gasPost = msg.gas;
        return gasPre - gasPost;
    }
}


contract PerfBytesConcatEmpty is BytesPerf {
    function perf() public payable returns (uint) {
        bytes memory bts = new bytes(0);
        uint gasPre = msg.gas;
        bts.concat(bts);
        uint gasPost = msg.gas;
        return gasPre - gasPost;
    }
}


contract PerfBytesHighestByteSetLow is BytesPerf {
    function perf() public payable returns (uint) {
        bytes memory bts = new bytes(0);
        uint gasPre = msg.gas;
        bytes32(1).highestByteSet();
        uint gasPost = msg.gas;
        return gasPre - gasPost;
    }
}


contract PerfBytesHighestByteSetHigh is BytesPerf {
    function perf() public payable returns (uint) {
        bytes memory bts = new bytes(0);
        uint gasPre = msg.gas;
        bytes32(~uint(0)).highestByteSet();
        uint gasPost = msg.gas;
        return gasPre - gasPost;
    }
}


contract PerfBytesLowestByteSetLow is BytesPerf {
    function perf() public payable returns (uint) {
        bytes memory bts = new bytes(0);
        uint gasPre = msg.gas;
        bytes32(1).lowestByteSet();
        uint gasPost = msg.gas;
        return gasPre - gasPost;
    }
}


contract PerfBytesLowestByteSetHigh is BytesPerf {
    function perf() public payable returns (uint) {
        bytes memory bts = new bytes(0);
        uint gasPre = msg.gas;
        bytes32(~uint(0)).lowestByteSet();
        uint gasPost = msg.gas;
        return gasPre - gasPost;
    }
}


contract PerfBytesToBytes is BytesPerf {
    function perf() public payable returns (uint) {
        bytes memory bts = new bytes(0);
        uint gasPre = msg.gas;
        bytes32(0x10203040).toBytes();
        uint gasPost = msg.gas;
        return gasPre - gasPost;
    }
}