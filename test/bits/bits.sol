pragma solidity ^0.4.16;
pragma experimental "v0.5.0";
pragma experimental "ABIEncoderV2";

import {Bits} from "../../src/bits/Bits.sol";
import {STLTest} from "../STLTest.sol";

/*******************************************************/

contract BitsTest is STLTest {
    using Bits for uint;

    uint internal constant ZERO = uint(0);
    uint internal constant ONE = uint(1);
    uint internal constant ONES = uint(~0);
}

/*******************************************************/

contract TestBitsBitAnd is BitsTest {
    function testImpl() internal {
        for (uint8 i = 0; i < 12; i++) {
            assert(ONES.bitAnd(ONES, i*20) == 1);
            assert(ONES.bitAnd(ZERO, i*20) == 0);
            assert(ZERO.bitAnd(ONES, i*20) == 0);
            assert(ZERO.bitAnd(ZERO, i*20) == 0);
        }
    }
}


contract TestBitsBitEqual is BitsTest {
    function testImpl() internal {
        for (uint8 i = 0; i < 12; i++) {
            assert(ONES.bitEqual(ONES, i*20));
            assert(!ONES.bitEqual(ZERO, i*20));
        }
    }
}


contract TestBitsBitNotSet is BitsTest {
    function testImpl() internal {
        for (uint8 i = 0; i < 12; i++) {
            assert(ONES.bitSet(i*20));
        }
    }
}


contract TestBitsBitOr is BitsTest {
    function testImpl() internal {
        for (uint8 i = 0; i < 12; i++) {
            assert(ONES.bitOr(ONES, i*20) == 1);
            assert(ONES.bitOr(ZERO, i*20) == 1);
            assert(ZERO.bitOr(ONES, i*20) == 1);
            assert(ZERO.bitOr(ZERO, i*20) == 0);
        }
    }
}


contract TestBitsBitSet is BitsTest {
    function testImpl() internal {
        for (uint8 i = 0; i < 12; i++) {
            assert(ONES.bitSet(i*20));
        }
    }
}


contract TestBitsBitsWithDifferentIndices is BitsTest {
    function testImpl() internal {
        for (uint8 i = 0; i < 12; i++) {
            assert(ONES.bits(i*20, 5) == 31);
        }
    }
}


contract TestBitsBitsWithDifferentNumBits is BitsTest {
    function testImpl() internal {
        for (uint8 i = 1; i < 12; i++) {
            assert(ONES.bits(0, i) == ONES >> (256 - i));
        }
    }
}


contract TestBitsBitsGetAll is BitsTest {
    function testImpl() internal {
        assert(ONES.bits(0, 256) == ONES);
    }
}


contract TestBitsBitsGetUpperHalf is BitsTest {
    function testImpl() internal {
        assert(ONES.bits(128, 128) == ONES >> 128);
    }
}


contract TestBitsBitsGetLowerHalf is BitsTest {
    function testImpl() internal {
        assert(ONES.bits(0, 128) == ONES >> 128);
    }
}


contract TestBitsBitsThrowsNumBitsZero is BitsTest {
    function testImpl() internal {
        ONES.bits(0, 0);
    }
}


contract TestBitsBitsThrowsIndexAndLengthOOB is BitsTest {
    function testImpl() internal {
        ONES.bits(5, 252);
    }
}


contract TestBitsBitXor is BitsTest {
    function testImpl() internal {
        for (uint8 i = 0; i < 12; i++) {
            assert(ONES.bitXor(ONES, i*20) == 0);
            assert(ONES.bitXor(ZERO, i*20) == 1);
            assert(ZERO.bitXor(ONES, i*20) == 1);
            assert(ZERO.bitXor(ZERO, i*20) == 0);
        }
    }
}


contract TestBitsClearBit is BitsTest {
    function testImpl() internal {
        for (uint8 i = 0; i < 12; i++) {
            assert(ONES.clearBit(i*20).bit(i*20) == 0);
        }
    }
}


contract TestBitsBit is BitsTest {
    function testImpl() internal {
        for (uint8 i = 0; i < 12; i++) {
            uint v = (ONE << i*20) * (i % 2);
            assert(v.bit(i*20) == i % 2);
        }
    }
}


contract TestBitsBitNot is BitsTest {
    function testImpl() internal {
        for (uint8 i = 0; i < 12; i++) {
            uint v = (ONE << i*20) * (i % 2);
            assert(v.bitNot(i*20) == 1 - i % 2);
        }
    }
}


contract TestBitsHighestBitSetAllLowerSet is BitsTest {
    function testImpl() internal {
        for (uint8 i = 0; i < 12; i += 20) {
            assert((ONES >> i).highestBitSet() == (255 - i));
        }
    }
}


contract TestBitsHighestBitSetSingleBit is BitsTest {
    function testImpl() internal {
        for (uint8 i = 0; i < 12; i += 20) {
            assert((ONE << i).highestBitSet() == i);
        }
    }
}


contract TestBitsHighestBitSetThrowsBitFieldIsZero is BitsTest {
    function testImpl() internal {
        ZERO.highestBitSet();
    }
}


contract TestBitsLowestBitSetAllHigherSet is BitsTest {
    function testImpl() internal {
        for (uint8 i = 0; i < 12; i += 20) {
            assert((ONES << i).lowestBitSet() == i);
        }
    }
}


contract TestBitsLowestBitSetSingleBit is BitsTest {
    function testImpl() internal {
        for (uint8 i = 0; i < 12; i += 20) {
            assert((ONE << i).lowestBitSet() == i);
        }
    }
}


contract TestBitsLowestBitSetThrowsBitFieldIsZero is BitsTest {
    function testImpl() internal {
        ZERO.lowestBitSet();
    }
}


contract TestBitsSetBit is BitsTest {
    function testImpl() internal {
        for (uint8 i = 0; i < 12; i++) {
            assert(ZERO.setBit(i*20) == ONE << i*20);
        }
    }
}


contract TestBitsToggleBit is BitsTest {
    function testImpl() internal {
        for (uint8 i = 0; i < 12; i++) {
            var v = ZERO.toggleBit(i*20);
            assert(v == ONE << i*20);
            assert(v.toggleBit(i*20) == 0);
        }
    }
}