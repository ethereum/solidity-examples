pragma solidity ^0.4.16;
pragma experimental "v0.5.0";
pragma experimental "ABIEncoderV2";

import {Memory} from "../../src/unsafe/Memory.sol";
import {STLPerf} from "../STLPerf.sol";


contract PerfMemoryEqualsOneWord is STLPerf {
    function perf() public payable returns (uint) {
        uint gasPre = msg.gas;
        Memory.equals(0, 0, 32);
        uint gasPost = msg.gas;
        return gasPre - gasPost;
    }
}


contract PerfMemoryEqualsHalfWord is STLPerf {
    function perf() public payable returns (uint) {
        uint gasPre = msg.gas;
        Memory.equals(0, 0, 16);
        uint gasPost = msg.gas;
        return gasPre - gasPost;
    }
}


contract PerfMemoryEqualsTenWords is STLPerf {
    function perf() public payable returns (uint) {
        uint gasPre = msg.gas;
        Memory.equals(0, 0, 320);
        uint gasPost = msg.gas;
        return gasPre - gasPost;
    }
}


contract PerfMemoryEqualsHundredWords is STLPerf {
    function perf() public payable returns (uint) {
        uint gasPre = msg.gas;
        Memory.equals(0, 0, 3200);
        uint gasPost = msg.gas;
        return gasPre - gasPost;
    }
}


contract PerfMemoryEqualsBytesOneWord is STLPerf {
    function perf() public payable returns (uint) {
        bytes memory bts = new bytes(32);
        uint addr = Memory.allocate(32);
        uint gasPre = msg.gas;
        Memory.equals(addr, 32, bts);
        uint gasPost = msg.gas;
        return gasPre - gasPost;
    }
}


contract PerfMemoryEqualsHundredWordsFailFirst is STLPerf {
    function perf() public payable returns (uint) {
        assembly {
            mstore(0x200, 6)
        }
        uint gasPre = msg.gas;
        Memory.equals(0, 0x200, 3200);
        uint gasPost = msg.gas;
        return gasPre - gasPost;
    }
}


contract PerfMemoryAllocateOneWord is STLPerf {
    function perf() public payable returns (uint) {
        uint gasPre = msg.gas;
        Memory.allocate(32);
        uint gasPost = msg.gas;
        return gasPre - gasPost;
    }
}


contract PerfMemoryAllocateTenWords is STLPerf {
    function perf() public payable returns (uint) {
        uint gasPre = msg.gas;
        Memory.allocate(320);
        uint gasPost = msg.gas;
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
    function perf() public payable returns (uint) {
        bytes memory bts = new bytes(0);
        uint gasPre = msg.gas;
        Memory.ptr(bts);
        uint gasPost = msg.gas;
        return gasPre - gasPost;
    }
}


contract PerfMemoryDataPtrBytes is STLPerf {
    function perf() public payable returns (uint) {
        bytes memory bts = new bytes(0);
        uint gasPre = msg.gas;
        Memory.dataPtr(bts);
        uint gasPost = msg.gas;
        return gasPre - gasPost;
    }
}


contract PerfMemoryFromBytes is STLPerf {
    function perf() public payable returns (uint) {
        bytes memory bts = new bytes(0);
        uint gasPre = msg.gas;
        Memory.fromBytes(bts);
        uint gasPost = msg.gas;
        return gasPre - gasPost;
    }
}


contract PerfMemoryPtrString is STLPerf {
    function perf() public payable returns (uint) {
        string memory str = new string(0);
        uint gasPre = msg.gas;
        Memory.ptr(str);
        uint gasPost = msg.gas;
        return gasPre - gasPost;
    }
}


contract PerfMemoryDataPtrString is STLPerf {
    function perf() public payable returns (uint) {
        string memory str = new string(0);
        uint gasPre = msg.gas;
        Memory.dataPtr(str);
        uint gasPost = msg.gas;
        return gasPre - gasPost;
    }
}


contract PerfMemoryFromString is STLPerf {
    function perf() public payable returns (uint) {
        string memory str = new string(0);
        uint gasPre = msg.gas;
        Memory.fromString(str);
        uint gasPost = msg.gas;
        return gasPre - gasPost;
    }
}


contract PerfMemoryToBytesOneWord is STLPerf {
    function perf() public payable returns (uint) {
        uint gasPre = msg.gas;
        Memory.toBytes(0, 32);
        uint gasPost = msg.gas;
        return gasPre - gasPost;
    }
}


contract PerfMemoryToStringOneWord is STLPerf {
    function perf() public payable returns (uint) {
        uint gasPre = msg.gas;
        Memory.toString(0, 32);
        uint gasPost = msg.gas;
        return gasPre - gasPost;
    }
}


contract PerfMemoryToUint is STLPerf {
    function perf() public payable returns (uint) {
        uint gasPre = msg.gas;
        Memory.toUint(0);
        uint gasPost = msg.gas;
        return gasPre - gasPost;
    }
}


contract PerfMemoryToBytes32 is STLPerf {
    function perf() public payable returns (uint) {
        uint gasPre = msg.gas;
        Memory.toBytes32(0);
        uint gasPost = msg.gas;
        return gasPre - gasPost;
    }
}


contract PerfMemoryToByte is STLPerf {
    function perf() public payable returns (uint) {
        uint gasPre = msg.gas;
        Memory.toByte(0, 0);
        uint gasPost = msg.gas;
        return gasPre - gasPost;
    }
}