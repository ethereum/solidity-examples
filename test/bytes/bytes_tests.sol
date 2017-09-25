pragma solidity ^0.4.16;
pragma experimental "v0.5.0";
pragma experimental "ABIEncoderV2";

import {Bytes} from "../../src/bytes/Bytes.sol";
import {Memory} from "../../src/unsafe/Memory.sol";
import {STLTest} from "../STLTest.sol";

/*******************************************************/

contract BytesTest is STLTest {
    using Bytes for bytes;
    using Bytes for bytes32;

    uint constant ZERO = uint(0);
    uint constant ONE = uint(1);
    uint constant ONES = uint(~0);

    bytes32 constant B32_ZERO = bytes32(0);
}

/*******************************************************/

contract TestBytesEqualsItselfWhenNull is BytesTest {
    function testImpl() internal {
        bytes memory btsNull = new bytes(0);
        assert(btsNull.equals(btsNull));
    }
}


contract TestBytesEqualsItself is BytesTest {
    function testImpl() internal {
        bytes memory bts = hex"8899aabbccddeeff8899aabbccddeeff8899aabbccddeeff8899aabbccddeeff8899aabbccddeeff8899aabbccddeeff8899aabbccddeeff8899aabbccddeeff8899aabbccddeeffaabb";
        assert(bts.equals(bts));
    }
}


contract TestBytesEqualsCommutative is BytesTest {
    function testImpl() internal {
        bytes memory bts1 = hex"8899aabbccddeeff8899aabbccddeeff8899aabbccddeeff8899aabbccddeeff8899aabbccddeeff8899aabbccddeeff8899aabbccddeeff8899aabbccddeeff8899aabbccddeeffaabb";
        bytes memory bts2 = hex"8899aabbccddeeff8899aabbccddeeff8899aabbccddeeff8899aabbccddeeff8899aabbccddeeff8899aabbccddeeff8899aabbccddeeff8899aabbccddeeff8899aabbccddeeffaabb";
        assert(bts1.equals(bts2) && bts2.equals(bts1));
    }
}


contract TestBytesEqualsNotEqualData is BytesTest {
    function testImpl() internal {
        bytes memory bts1 = hex"8899aabbccddeeff8899aabbccddeeff8899aabbccddeeff8899aabbccddeeff8899aabbccddeeff8899aabbccddeeff8899aabbccddeeff8899aabbccddeeff8899aabbccddeeffaabb";
        bytes memory bts2 = hex"8899aabbccddeeff8899aabbccddeeff8899aabbccddeeff8899aabbccddeeff8899aabbccddeeff8899aabbccddeeff8899aabbccddeeff8899aabbccddee8899aabbccddeeffaabbff";
        assert(!bts1.equals(bts2));
    }
}


contract TestBytesEqualsNotEqualLength is BytesTest {
    function testImpl() internal {
        bytes memory bts1 = hex"8899aabbccddeeff8899";
        bytes memory bts2 = hex"8899aabbccddeeff88";
        assert(!bts1.equals(bts2));
    }
}


contract TestBytesEqualsNotEqualCommutative is BytesTest {
    function testImpl() internal {
        bytes memory bts1 = hex"8899aabbccddeeff8899aabbccddeeff8899aabbccddeeff8899aabbccddeeff8899aabbccddeeff8899aabbccddeeff8899aabbccddeeff8899aabbccddeeff8899aabbccddeeffaabb";
        bytes memory bts2 = hex"8899aabbccddeeff8899aabbccddeeff8899aabbccddeeff8899aabbccddeeff8899aabbccddeeff8899aabbccddeeff8899aabbccddeeff8899aabbccddee8899aabbccddeeffaabbff";
        assert(!bts1.equals(bts2) && !bts2.equals(bts1));
    }
}


contract TestBytesEqualsRef is BytesTest {
    function testImpl() internal {
        bytes memory bts = hex"8899aabbccddeeff8899aabbccddeeff8899aabbccddeeff8899aabbccddeeff8899aabbccddeeff8899aabbccddeeff8899aabb";
        assert(bts.equalsRef(bts));
    }
}


contract TestBytesEqualsRefNotEqual is BytesTest {
    function testImpl() internal {
        bytes memory bts1 = hex"8899aabb";
        bytes memory bts2 = hex"8899aabb";
        assert(!bts1.equalsRef(bts2));
    }
}


contract TestBytesEqualsRefFailNotEqualCommutative is BytesTest {
    function testImpl() internal {
        bytes memory bts1 = hex"8899aabb";
        bytes memory bts2 = hex"8899aabb";
        assert(!bts1.equalsRef(bts2) && !bts2.equalsRef(bts1));
    }
}


contract TestBytesCopyNull is BytesTest {
    function testImpl() internal {
        bytes memory bts = new bytes(0);
        var cpy = bts.copy();
        assert(cpy.length == 0);
    }
}


contract TestBytesCopy is BytesTest {
    function testImpl() internal {
         bytes memory bts = hex"8899aabbccddeeff8899aabbccddeeff8899aabbccddeeff8899aabbccddeeff8899aabbccddeeff8899aabbccddeeff8899aabbccddeeff8899aabbccddeeff8899aabbccddeeffaabb";
         var cpy = bts.copy();
         assert(bts.equals(cpy));
    }
}


contract TestBytesCopyCreatesNew is BytesTest {
    function testImpl() internal {
         bytes memory bts = hex"8899aabbccddeeff8899aabbccddeeff8899aabbccddeeff8899aabbccddeeff8899aabbccddeeff8899aabbccddeeff8899aabbccddeeff8899aabbccddeeff8899aabbccddeeffaabb";
         var cpy = bts.copy();
         assert(Memory.ptr(bts) != Memory.ptr(cpy));
    }
}


contract TestBytesCopyDoesNotMutate is BytesTest {
    function testImpl() internal {
         bytes memory bts = hex"8899aabbccddeeff8899aabbccddeeff8899aabbccddeeff8899aabbccddeeff8899aabbccddeeff8899aabbccddeeff8899aabbccddeeff8899aabbccddeeff8899aabbccddeeffaabb";
         bytes memory btsEq = hex"8899aabbccddeeff8899aabbccddeeff8899aabbccddeeff8899aabbccddeeff8899aabbccddeeff8899aabbccddeeff8899aabbccddeeff8899aabbccddeeff8899aabbccddeeffaabb";
         var btsLen = bts.length;
         var btsAddr = Memory.ptr(bts);
         bts.copy();
         assert(Memory.ptr(bts) == btsAddr);
         assert(bts.length == btsLen);
         assert(bts.equals(btsEq));
    }
}


contract TestBytesCopyWithStartIndex is BytesTest {
    function testImpl() internal {
         bytes memory bts = hex"8899aabbccddeeff8899aabbccddeeff8899aabbccddeeff8899aabbccddeeff8899aabbccddeeff8899aabbccddeeff8899aabbccddeeff8899aabbccddeeff8899aabbccddeeffaabb";
         var cpy = bts.copy(1);
         var sdp = Memory.dataPtr(bts);
         var cdp = Memory.dataPtr(cpy);
         assert(bts.length == cpy.length + 1);
         assert(Memory.equals(sdp + 1, cdp, cpy.length));
    }
}


contract TestBytesCopyWithStartIndexDoesNotMutate is BytesTest {
    function testImpl() internal {
         bytes memory bts = hex"8899aabbccddeeff8899aabbccddeeff8899aabbccddeeff8899aabbccddeeff8899aabbccddeeff8899aabbccddeeff8899aabbccddeeff8899aabbccddeeff8899aabbccddeeffaabb";
         bytes memory btsEq = hex"8899aabbccddeeff8899aabbccddeeff8899aabbccddeeff8899aabbccddeeff8899aabbccddeeff8899aabbccddeeff8899aabbccddeeff8899aabbccddeeff8899aabbccddeeffaabb";
         var btsLen = bts.length;
         var btsAddr = Memory.ptr(bts);
         bts.copy(4);
         assert(Memory.ptr(bts) == btsAddr);
         assert(bts.equals(btsEq));
    }
}


contract TestBytesCopyWithStartIndexThrowsIndexOOB is BytesTest {
    function testImpl() internal {
         bytes memory bts = new bytes(0);
         bts.copy(1);
    }
}


contract TestBytesCopyWithStartIndexAndLen is BytesTest {
    function testImpl() internal {
         bytes memory bts = hex"8899aabbccddeeff8899aabbccddeeff8899aabbccddeeff8899aabbccddeeff8899aabbccddeeff8899aabbccddeeff8899aabbccddeeff8899aabbccddeeff8899aabbccddeeffaabb";
         var cpy = bts.copy(7, 12);
         var sdp = Memory.dataPtr(bts);
         var cdp = Memory.dataPtr(cpy);
         assert(cpy.length == 12);
         assert(Memory.equals(sdp + 7, cdp, 12));
    }
}


contract TestBytesCopyWithStartIndexAndLenFull is BytesTest {
    function testImpl() internal {
         bytes memory bts = hex"8899aabbccddeeff8899aabbccddeeff8899aabbccddeeff8899aabbccddeeff8899aabbccddeeff8899aabbccddeeff8899aabbccddeeff8899aabbccddeeff8899aabbccddeeffaabb";
         var cpy = bts.copy(0, bts.length);
         var sdp = Memory.dataPtr(bts);
         var cdp = Memory.dataPtr(cpy);
         assert(cpy.length == bts.length);
         assert(Memory.equals(sdp, cdp, bts.length));
    }
}


contract TestBytesCopyWithStartIndexAndLenEmptyBytes is BytesTest {
    function testImpl() internal {
         bytes memory bts = hex"8899aabbccddeeff8899aabbccddeeff8899aabbccddeeff8899aabbccddeeff8899aabbccddeeff8899aabbccddeeff8899aabbccddeeff8899aabbccddeeff8899aabbccddeeffaabb";
         var cpy = bts.copy(0, 0);
         assert(cpy.length == 0);
    }
}


contract TestBytesCopyWithStartIndexAndLenDoesNotMutate is BytesTest {
    function testImpl() internal {
         bytes memory bts = hex"8899aabbccddeeff8899aabbccddeeff8899aabbccddeeff8899aabbccddeeff8899aabbccddeeff8899aabbccddeeff8899aabbccddeeff8899aabbccddeeff8899aabbccddeeffaabb";
         bytes memory btsEq = hex"8899aabbccddeeff8899aabbccddeeff8899aabbccddeeff8899aabbccddeeff8899aabbccddeeff8899aabbccddeeff8899aabbccddeeff8899aabbccddeeff8899aabbccddeeffaabb";
         var btsLen = bts.length;
         var btsAddr = Memory.ptr(bts);
         bts.copy(4, 21);
         assert(Memory.ptr(bts) == btsAddr);
         assert(bts.equals(btsEq));
    }
}


contract TestBytesCopyWithStartIndexAndLenThrowsIndexOOB is BytesTest {
    function testImpl() internal {
         bytes memory bts = new bytes(0);
         bts.copy(1, 0);
    }
}

contract TestBytesCopyWithStartIndexAndLenThrowsIndexPlusLengthOOB is BytesTest {
    function testImpl() internal {
         bytes memory bts = new bytes(1);
         bts.copy(0, 2);
    }
}


contract TestBytesConcatNull is BytesTest {
    function testImpl() internal {
        bytes memory bts = new bytes(0);
        var cnct = bts.concat(bts);
        assert(cnct.length == 0);
        assert(!bts.equalsRef(cnct));
    }
}


contract TestBytesConcatSelf is BytesTest {
    function testImpl() internal {
        bytes memory bts = hex"aabbccdd";
        var cnct = bts.concat(bts);
        var btsLen = bts.length;
        assert(cnct.length == 2*btsLen);
        for (uint i = 0; i < btsLen; i++) {
            cnct[i] == bts[i];
            cnct[i + btsLen] == bts[i];
        }
    }
}


contract TestBytesConcat is BytesTest {
    function testImpl() internal {
        bytes memory bts1 = hex"aabbccddeeff8899aabbccddeeff8899aabbccddeeff8899";
        bytes memory bts2 = hex"aabbccddeeffaabbccddeeffaabbcc";

        var cnct = bts1.concat(bts2);
        var bts1Len = bts1.length;
        var bts2Len = bts2.length;
        assert(cnct.length == bts1Len + bts2Len);
        for (uint i = 0; i < bts1Len; i++) {
            cnct[i] == bts1[i];
        }
        for (i = 0; i < bts2Len; i++) {
            cnct[i + bts1Len] == bts2[i];
        }
    }
}


contract TestBytesConcatCreatesNew is BytesTest {
    function testImpl() internal {
        bytes memory bts = new bytes(0);
        var cnct = bts.concat(bts);
        assert(!bts.equalsRef(cnct));
    }
}


contract TestBytesConcatDoesNotMutate is BytesTest {
    function testImpl() internal {
         bytes memory bts1 = hex"8899aabbccddeeff8899aabbccddeeff8899aabbccddeeff8899aabbccddeeff8899aabbccddeeff8899aabbccddeeff8899aabbccddeeff8899aabbccddeeff8899aabbccddeeffaabb";
         bytes memory bts1Eq = hex"8899aabbccddeeff8899aabbccddeeff8899aabbccddeeff8899aabbccddeeff8899aabbccddeeff8899aabbccddeeff8899aabbccddeeff8899aabbccddeeff8899aabbccddeeffaabb";
         bytes memory bts2 = hex"ddeeff8899aabbccddeeff8899aabbccaabbccddeeff8899aabbccddeeff8899aa";
         bytes memory bts2Eq = hex"ddeeff8899aabbccddeeff8899aabbccaabbccddeeff8899aabbccddeeff8899aa";
         var bts1Len = bts1.length;
         var bts2Len = bts2.length;
         var bts1Addr = Memory.ptr(bts1);
         var bts2Addr = Memory.ptr(bts2);
         bts1.concat(bts2);
         assert(bts1.length == bts1Len);
         assert(bts2.length == bts2Len);
         assert(Memory.ptr(bts1) == bts1Addr);
         assert(Memory.ptr(bts2) == bts2Addr);
         assert(bts1.equals(bts1Eq));
         assert(bts2.equals(bts2Eq));
    }
}


contract TestBytesLowestByteSetAllHigherSet is BytesTest {
    function testImpl() internal {
        for (uint8 i = 0; i < 32; i++) {
            assert(bytes32(ONES << 8*i).lowestByteSet() == i);
        }
    }
}


contract TestBytesLowestByteSetSingleByte is BytesTest {
    function testImpl() internal {
        for (uint8 i = 0; i < 32; i++) {
            assert(bytes32(ONE << 8*i).lowestByteSet() == i);
        }
    }
}


contract TestBytesLowestByteSetThrowsBytes32IsZero is BytesTest {
    function testImpl() internal {
        B32_ZERO.lowestByteSet();
    }
}


contract TestBytesHighestByteSetAllLowerSet is BytesTest {
    function testImpl() internal {
        for (uint8 i = 0; i < 31; i++) {
            assert(bytes32(ONES >> 8*i).highestByteSet() == (31 - i));
        }
    }
}


contract TestBytesHighestByteSetSingleByte is BytesTest {
    function testImpl() internal {
        for (uint8 i = 0; i < 32; i++) {
            assert(bytes32(ONE << 8*i).highestByteSet() == i);
        }
    }
}


contract TestBytesHighestByteSetThrowsBytes32IsZero is BytesTest {
    function testImpl() internal {
        B32_ZERO.highestByteSet();
    }
}


contract TestBytesToBytes32HighOrderBytes is BytesTest {
    function testImpl() internal {
        var bts = bytes32(hex"11223344").toBytes();
        bytes memory btsExp = hex"11223344";
        assert(bts.equals(btsExp));
    }
}


contract TestBytesToBytes32LowOrderBytes is BytesTest {
    function testImpl() internal {
        var bts = bytes32(0x11223344).toBytes();
        bytes memory btsExp = hex"0000000000000000000000000000000000000000000000000000000011223344";
        assert(bts.equals(btsExp));
    }
}


contract TestBytesToBytes32Zero is BytesTest {
    function testImpl() internal {
        var bts = B32_ZERO.toBytes();
        bytes memory btsExp = new bytes(0);
        assert(bts.equals(btsExp));
    }
}