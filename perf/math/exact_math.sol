pragma solidity ^0.4.16;
pragma experimental "v0.5.0";
pragma experimental "ABIEncoderV2";

import {ExactMath} from "../../src/math/ExactMath.sol";
import {STLPerf} from "../STLPerf.sol";


contract PerfMathExactAddUint is STLPerf {
    uint public res;

    function perf() public payable returns (uint) {
        uint n = 5;
        uint m = 2;
        uint gasPre = msg.gas;
        var res_ = ExactMath.exactAdd(n, m);
        uint gasPost = msg.gas;
        res = res_;
        return gasPre - gasPost;
    }
}


contract PerfMathExactSubUint is STLPerf {
    uint public res;

    function perf() public payable returns (uint) {
        uint n = 5;
        uint m = 2;
        uint gasPre = msg.gas;
        var res_ = ExactMath.exactSub(n, m);
        uint gasPost = msg.gas;
        res = res_;
        return gasPre - gasPost;
    }
}


contract PerfMathExactMulUint is STLPerf {
    uint public res;

    function perf() public payable returns (uint) {
        uint n = 5;
        uint m = 2;
        uint gasPre = msg.gas;
        var res_ = ExactMath.exactMul(n, m);
        uint gasPost = msg.gas;
        res = res_;
        return gasPre - gasPost;
    }
}


contract PerfMathExactAddInt is STLPerf {
    int public res;

    function perf() public payable returns (uint) {
        int n = 5;
        int m = 2;
        uint gasPre = msg.gas;
        var res_ = ExactMath.exactAdd(n, m);
        uint gasPost = msg.gas;
        res = res_;
        return gasPre - gasPost;
    }
}


contract PerfMathExactSubInt is STLPerf {
    int public res;

    function perf() public payable returns (uint) {
        int n = 5;
        int m = 2;
        uint gasPre = msg.gas;
        var res_ = ExactMath.exactSub(n, m);
        uint gasPost = msg.gas;
        res = res_;
        return gasPre - gasPost;
    }
}


contract PerfMathExactMulInt is STLPerf {
    int public res;

    function perf() public payable returns (uint) {
        int n = 5;
        int m = 2;
        uint gasPre = msg.gas;
        var res_ = ExactMath.exactMul(n, m);
        uint gasPost = msg.gas;
        res = res_;
        return gasPre - gasPost;
    }
}


contract PerfMathExactDivInt is STLPerf {
    int public res;

    function perf() public payable returns (uint) {
        int n = 5;
        int m = 2;
        uint gasPre = msg.gas;
        var res_ = ExactMath.exactDiv(n, m);
        uint gasPost = msg.gas;
        res = res_;
        return gasPre - gasPost;
    }
}