pragma solidity ^0.4.16;
pragma experimental "v0.5.0";
pragma experimental "ABIEncoderV2";

import {ExactMath} from "../src/math/ExactMath.sol";


contract MathExamples {

    using ExactMath for int;
    using ExactMath for uint;

    // Add exact uints example.
    function uintExactAddOverflowExample() public pure {
        var n = uint(~0);
        n.exactAdd(1);
    }

    // Subtract exact uints example.
    function uintExactSubUnderflowExample() public pure {
        var n = uint(0);
        n.exactSub(1);
    }

    // Multiply exact uints example.
    function uintExactMulOverflowExample() public pure {
        var n = uint(~0);
        n.exactMul(2);
    }

    // Add exact ints example.
    function intExactAddOverflowExample() public pure {
        int n = 2**255 - 1;
        n.exactAdd(1);
    }

    // Add exact ints example.
    function intExactAddUnderflowExample() public pure {
        int n = int(2**255);
        n.exactAdd(-1);
    }

    // Subtract exact ints example.
    function intExactSubOverflowExample() public pure {
        var n = int(2**255 - 1);
        n.exactSub(-1);
    }

    // Subtract exact ints example.
    function intExactSubUnderflowExample() public pure {
        var n = int(2**255);
        n.exactSub(1);
    }

    // Multiply exact ints example.
    function intExactMulOverflowExample() public pure {
        var n = int(2**255 - 1);
        n.exactMul(2);
    }

    // Multiply exact ints example.
    function intExactMulUnderflowExample() public pure {
        var n = int(2**255);
        n.exactMul(2);
    }

    // Multiply exact ints example.
    function intExactMulIllegalUseOfIntMinExample() public pure {
        var n = int(2**255);
        n.exactMul(-1);
    }

    // Multiply exact ints example.
    function intExactMulIllegalUseOfIntMinExample2() public pure {
        var n = int(-1);
        n.exactMul(int(2**255));
    }

    // Multiply exact ints example.
    function intExactDivIllegalUseOfIntMinExample() public pure {
        var n = int(2**255);
        n.exactDiv(-1);
    }
}