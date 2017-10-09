pragma solidity ^0.4.16;
pragma experimental "v0.5.0";
pragma experimental "ABIEncoderV2";

import {Math} from '../src/math/Math.sol';

contract MathExamples {

    // Add exact example.
    function uintExactAddExample() public pure {
        // This will detect overflow and throw.
        var n = uint(~0);
        n.exactAdd(1);
    }
}