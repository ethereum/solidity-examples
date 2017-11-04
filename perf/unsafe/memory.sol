pragma solidity ^0.4.16;
pragma experimental "v0.5.0";
pragma experimental "ABIEncoderV2";

import {Memory} from "../../src/unsafe/Memory.sol";
import {STLPerf} from "../STLPerf.sol";


contract PerfMemoryEqualsOneWord is STLPerf {
    bool public res;

    function perf() public payable returns (uint) {
        uint gasPre = msg.gas;
        var res_ = Memory.equals(0, 0, 32);
        uint gasPost = msg.gas;
        res = res_;
        return gasPre - gasPost;
    }
}


contract PerfMemoryEqualsHalfWord is STLPerf {
    bool public res;

    function perf() public payable returns (uint) {
        uint gasPre = msg.gas;
        var res_ = Memory.equals(0, 0, 16);
        uint gasPost = msg.gas;
        res = res_;
        return gasPre - gasPost;
    }
}


contract PerfMemoryEqualsTenWords is STLPerf {
    bool public res;

    function perf() public payable returns (uint) {
        uint gasPre = msg.gas;
        var res_ = Memory.equals(0, 0, 320);
        uint gasPost = msg.gas;
        res = res_;
        return gasPre - gasPost;
    }
}


contract PerfMemoryEqualsHundredWords is STLPerf {
    bool public res;

    function perf() public payable returns (uint) {
        uint gasPre = msg.gas;
        var res_ = Memory.equals(0, 0, 3200);
        uint gasPost = msg.gas;
        res = res_;
        return gasPre - gasPost;
    }
}


contract PerfMemoryEqualsBytesOneWord is STLPerf {
    bool public res;

    function perf() public payable returns (uint) {
        bytes memory bts = new bytes(32);
        uint addr = Memory.allocate(32);
        uint gasPre = msg.gas;
        var res_ = Memory.equals(addr, 32, bts);
        uint gasPost = msg.gas;
        res = res_;
        return gasPre - gasPost;
    }
}


contract PerfMemoryEqualsHundredWordsFailFirst is STLPerf {
    bool public res;

    function perf() public payable returns (uint) {
        assembly {
            mstore(0x200, 6)
        }
        uint gasPre = msg.gas;
        var res_ = Memory.equals(0, 0x200, 3200);
        uint gasPost = msg.gas;
        res = res_;
        return gasPre - gasPost;
    }
}


contract PerfMemoryAllocateOneWord is STLPerf {
    uint public res;

    function perf() public payable returns (uint) {
        uint gasPre = msg.gas;
        var res_ = Memory.allocate(32);
        uint gasPost = msg.gas;
        res = res_;
        return gasPre - gasPost;
    }
}


contract PerfMemoryAllocateTenWords is STLPerf {
    uint public res;

    function perf() public payable returns (uint) {
        uint gasPre = msg.gas;
        var res_ = Memory.allocate(320);
        uint gasPost = msg.gas;
        res = res_;
        return gasPre - gasPost;
    }
}


contract PerfMemoryCopyOneWord is STLPerf {
    function perf() public payable returns (uint) {
        var a = Memory.allocate(32);
        var b = Memory.allocate(32);
        uint gasPre = msg.gas;
        Memory.copy(a, b, 32);
        uint gasPost = msg.gas;
        return gasPre - gasPost;
    }
}


contract PerfMemoryCopyHalfWord is STLPerf {
    function perf() public payable returns (uint) {
        var a = Memory.allocate(16);
        var b = Memory.allocate(16);
        uint gasPre = msg.gas;
        Memory.copy(a, b, 16);
        uint gasPost = msg.gas;
        return gasPre - gasPost;
    }
}


contract PerfMemoryCopyTenWords is STLPerf {
    function perf() public payable returns (uint) {
        var a = Memory.allocate(320);
        var b = Memory.allocate(320);
        uint gasPre = msg.gas;
        Memory.copy(a, b, 320);
        uint gasPost = msg.gas;
        return gasPre - gasPost;
    }
}


contract PerfMemoryPtrBytes is STLPerf {
    uint public res;

    function perf() public payable returns (uint) {
        bytes memory bts = new bytes(0);
        uint gasPre = msg.gas;
        var res_ = Memory.ptr(bts);
        uint gasPost = msg.gas;
        res = res_;
        return gasPre - gasPost;
    }
}


contract PerfMemoryDataPtrBytes is STLPerf {
    uint public res;

    function perf() public payable returns (uint) {
        bytes memory bts = new bytes(0);
        uint gasPre = msg.gas;
        var res_ = Memory.dataPtr(bts);
        uint gasPost = msg.gas;
        res = res_;
        return gasPre - gasPost;
    }
}


contract PerfMemoryFromBytes is STLPerf {
    uint public res;

    function perf() public payable returns (uint) {
        bytes memory bts = new bytes(0);
        uint gasPre = msg.gas;
        var (res_, ) = Memory.fromBytes(bts);
        uint gasPost = msg.gas;
        res = res_;
        return gasPre - gasPost;
    }
}


contract PerfMemoryToBytesOneWord is STLPerf {
    bytes public res;

    function perf() public payable returns (uint) {
        uint gasPre = msg.gas;
        var res_ = Memory.toBytes(0, 32);
        uint gasPost = msg.gas;
        res = res_;
        return gasPre - gasPost;
    }
}


contract PerfMemoryToUint is STLPerf {
    uint public res;

    function perf() public payable returns (uint) {
        uint gasPre = msg.gas;
        var res_ = Memory.toUint(0);
        uint gasPost = msg.gas;
        res = res_;
        return gasPre - gasPost;
    }
}


contract PerfMemoryToBytes32 is STLPerf {
    bytes32 public res;

    function perf() public payable returns (uint) {
        uint gasPre = msg.gas;
        var res_ = Memory.toBytes32(0);
        uint gasPost = msg.gas;
        res = res_;
        return gasPre - gasPost;
    }
}

/*
contract PerfMemoryToByte is STLPerf {
    byte public res;

    function perf() public payable returns (uint) {
        uint gasPre = msg.gas;
        var res_ = Memory.toByte(0, 0);
        uint gasPost = msg.gas;
        res = res_;
        return gasPre - gasPost;
    }
}
*/
