pragma solidity ^0.4.16;
pragma experimental "v0.5.0";
pragma experimental "ABIEncoderV2";

import {ExactMath} from "../../src/math/ExactMath.sol";
import {STLPerf} from "../STLPerf.sol";


contract PerfMathExactAddUint is STLPerf {
    function perf() public payable returns (uint) {
        uint gasPre = msg.gas;
        ExactMath.exactAdd(uint(5), uint(2));
        uint gasPost = msg.gas;
        return gasPre - gasPost;
    }
}


contract PerfMathExactSubUint is STLPerf {
    function perf() public payable returns (uint) {
        uint gasPre = msg.gas;
        ExactMath.exactSub(uint(5), uint(2));
        uint gasPost = msg.gas;
        return gasPre - gasPost;
    }
}


contract PerfMathExactMulUint is STLPerf {
    function perf() public payable returns (uint) {
        uint gasPre = msg.gas;
        ExactMath.exactMul(uint(5), uint(2));
        uint gasPost = msg.gas;
        return gasPre - gasPost;
    }
}


contract PerfMathExactAddInt is STLPerf {
    function perf() public payable returns (uint) {
        uint gasPre = msg.gas;
        ExactMath.exactAdd(int(5), int(2));
        uint gasPost = msg.gas;
        return gasPre - gasPost;
    }
}


contract PerfMathExactSubInt is STLPerf {
    function perf() public payable returns (uint) {
        uint gasPre = msg.gas;
        ExactMath.exactSub(int(5), int(2));
        uint gasPost = msg.gas;
        return gasPre - gasPost;
    }
}


contract PerfMathExactMulInt is STLPerf {
    function perf() public payable returns (uint) {
        uint gasPre = msg.gas;
        ExactMath.exactMul(int(5), int(2));
        uint gasPost = msg.gas;
        return gasPre - gasPost;
    }
}


contract PerfMathExactDivInt is STLPerf {
    function perf() public payable returns (uint) {
        uint gasPre = msg.gas;
        ExactMath.exactDiv(int(5), int(2));
        uint gasPost = msg.gas;
        return gasPre - gasPost;
    }
}