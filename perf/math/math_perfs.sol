pragma solidity ^0.4.16;
pragma experimental "v0.5.0";
pragma experimental "ABIEncoderV2";

import {Math} from "../../src/math/Math.sol";
import {STLPerf} from "../STLPerf.sol";


contract PerfMathExactAddUint is STLPerf {
    function perf() public payable returns (uint) {
        uint gasPre = msg.gas;
        Math.exactAdd(uint(5), uint(2));
        uint gasPost = msg.gas;
        return gasPre - gasPost;
    }
}


contract PerfMathExactSubUint is STLPerf {
    function perf() public payable returns (uint) {
        uint gasPre = msg.gas;
        Math.exactSub(uint(5), uint(2));
        uint gasPost = msg.gas;
        return gasPre - gasPost;
    }
}


contract PerfMathExactMulUint is STLPerf {
    function perf() public payable returns (uint) {
        uint gasPre = msg.gas;
        Math.exactMul(uint(5), uint(2));
        uint gasPost = msg.gas;
        return gasPre - gasPost;
    }
}


contract PerfMathExactAddInt is STLPerf {
    function perf() public payable returns (uint) {
        uint gasPre = msg.gas;
        Math.exactAdd(int(5), int(2));
        uint gasPost = msg.gas;
        return gasPre - gasPost;
    }
}


contract PerfMathExactSubInt is STLPerf {
    function perf() public payable returns (uint) {
        uint gasPre = msg.gas;
        Math.exactSub(int(5), int(2));
        uint gasPost = msg.gas;
        return gasPre - gasPost;
    }
}


contract PerfMathExactMulInt is STLPerf {
    function perf() public payable returns (uint) {
        uint gasPre = msg.gas;
        Math.exactMul(int(5), int(2));
        uint gasPost = msg.gas;
        return gasPre - gasPost;
    }
}


contract PerfMathExactDivInt is STLPerf {
    function perf() public payable returns (uint) {
        uint gasPre = msg.gas;
        Math.exactDiv(int(5), int(2));
        uint gasPost = msg.gas;
        return gasPre - gasPost;
    }
}