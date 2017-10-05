pragma solidity ^0.4.16;
pragma experimental "v0.5.0";
pragma experimental "ABIEncoderV2";

import {STLTest} from "../STLTest.sol";

contract TestMathUint256Overflow is STLTest {

    uint constant ZERO = 0;
    uint constant ONE = 1;
    uint constant TWO = 2;
    uint constant ONES = ~uint(0);
    uint constant HALF = uint(1) << 128;

    function testImpl() internal {
        uint n;

        // +
        assert(ONES + ONE == ZERO);
        // ++
        n = ONES;
        n++;
        assert(n == ZERO);
        n = ONES;
        ++n;
        assert(n == ZERO);
        // +=
        n = ONES;
        n += ONE;
        assert(n == ZERO);

        // -
        assert(ZERO - ONE == ONES);
        // --
        n = ZERO;
        n--;
        assert(n == ONES);
        n = ZERO;
        --n;
        assert(n == ONES);
        // -=
        n = ZERO;
        n -= ONE;
        assert(n == ONES);
        // - (unary)
        assert(-ONE == ONES);

        // *
        assert(HALF * HALF == ZERO);
        // *=
        n = HALF;
        n *= HALF;
        assert(n == ZERO);
        assert(TWO ** 256 == ZERO);

    }
}

contract TestMathInt256Overflow is STLTest {

    int constant ZERO = 0;
    int constant ONE = 1;
    int constant TWO = 2;
    int constant MINUS_ONE = -1;
    int constant HALF = int(1) << 128;
    int constant INT_MAX = int(2**255 - 1);
    int constant INT_MIN = int(-(2**255));


    function testImpl() internal {
        int n;

        // +
        assert(INT_MAX + ONE == INT_MIN);

        // ++
        n = INT_MAX;
        n++;
        assert(n == INT_MIN);
        n = INT_MAX;
        ++n;
        assert(n == INT_MIN);
        // +=
        n = INT_MAX;
        n += ONE;
        assert(n == INT_MIN);

        // -
        assert(INT_MIN - ONE == INT_MAX);
        // --
        n = INT_MIN;
        n--;
        assert(n == INT_MAX);
        n = INT_MIN;
        --n;
        assert(n == INT_MAX);
        // -=
        n = INT_MIN;
        n -= ONE;
        assert(n == INT_MAX);
        // - (unary)
        assert(-INT_MIN == INT_MIN);

        // *
        assert(INT_MIN*MINUS_ONE == INT_MIN);
        assert(MINUS_ONE*INT_MIN == INT_MIN);
        // *=
        n = INT_MIN;
        n *= MINUS_ONE;
        assert(n == INT_MIN);

        // /
        assert(INT_MIN / MINUS_ONE == INT_MIN);
        // /=
        n = INT_MIN;
        n /= MINUS_ONE;
        assert(n == INT_MIN);

        // <<

    }
}


contract TestMathUint256DivWithZeroThrows is STLTest {

    function testImpl() internal {
        uint x = 5;
        uint y = 0;
        x / y;
    }

}


contract TestMathUint256RemainderWithZeroThrows is STLTest {

    function testImpl() internal {
        uint x = 5;
        uint y = 0;
        x % y;
    }

}


contract TestMathInt256DivWithZeroThrows is STLTest {

    function testImpl() internal {
        int x = 5;
        int y = 0;
        x / y;
    }

}


contract TestMathInt256RemainderWithZeroThrows is STLTest {

    function testImpl() internal {
        int x = 5;
        int y = 0;
        x % y;
    }

}