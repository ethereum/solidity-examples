pragma solidity ^0.4.16;
pragma experimental "v0.5.0";
pragma experimental ABIEncoderV2;

import {Memory} from "../../src/unsafe/Memory.sol";
import {STLPerf} from "../STLPerf.sol";


contract PerfMemoryEqualsOneWord is STLPerf {
    function perfImpl() internal {
        Memory.equals(0, 0, 32);
    }
}


contract PerfMemoryEqualsHalfWord is STLPerf {
    function perfImpl() internal {
        Memory.equals(0, 0, 16);
    }
}


contract PerfMemoryEqualsTenWords is STLPerf {
    function perfImpl() internal {
        Memory.equals(0, 0, 320);
    }
}


contract PerfMemoryEqualsHundredWords is STLPerf {
    function perfImpl() internal {
        Memory.equals(0, 0, 3200);
    }
}

contract PerfMemoryEqualsHundredWordsFailFirst is STLPerf {
    function perfImpl() internal {
        assembly {
            mstore(0x200, 6)
        }
        Memory.equals(0, 0x200, 3200);
    }
}


contract PerfMemoryAllocate is STLPerf {
    function perfImpl() internal {
        Memory.allocate(55);
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