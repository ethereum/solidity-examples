pragma solidity ^0.4.16;
pragma experimental "v0.5.0";
pragma experimental "ABIEncoderV2";

import {Bytes} from "../../src/bytes/Bytes.sol";
import {Memory} from "../../src/unsafe/Memory.sol";
import {STLTest} from "../STLTest.sol";

/* solhint-disable max-line-length */
/*******************************************************/

contract BytesTest is STLTest {
    using Bytes for *;

    uint internal constant ZERO = uint(0);
    uint internal constant ONE = uint(1);
    uint internal constant ONES = uint(~0);

    bytes32 internal constant B32_ZERO = bytes32(0);
}

/************************** Equals ***************************/

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

/************************** EqualsRef ***************************/

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

/************************** Copy ***************************/

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

/************************** substr ***************************/

contract TestBytesSubstr is BytesTest {
    function testImpl() internal {
        bytes memory bts = hex"8899aabbccddeeff8899aabbccddeeff8899aabbccddeeff8899aabbccddeeff8899aabbccddeeff8899aabbccddeeff8899aabbccddeeff8899aabbccddeeff8899aabbccddeeffaabb";
        var cpy = bts.substr(1);
        var sdp = Memory.dataPtr(bts);
        var cdp = Memory.dataPtr(cpy);
        assert(bts.length == cpy.length + 1);
        assert(Memory.equals(sdp + 1, cdp, cpy.length));
    }
}


contract TestBytesSubstrDoesNotMutate is BytesTest {
    function testImpl() internal {
        bytes memory bts = hex"8899aabbccddeeff8899aabbccddeeff8899aabbccddeeff8899aabbccddeeff8899aabbccddeeff8899aabbccddeeff8899aabbccddeeff8899aabbccddeeff8899aabbccddeeffaabb";
        bytes memory btsEq = hex"8899aabbccddeeff8899aabbccddeeff8899aabbccddeeff8899aabbccddeeff8899aabbccddeeff8899aabbccddeeff8899aabbccddeeff8899aabbccddeeff8899aabbccddeeffaabb";
        var btsAddr = Memory.ptr(bts);
        bts.substr(4);
        assert(Memory.ptr(bts) == btsAddr);
        assert(bts.equals(btsEq));
    }
}


contract TestBytesSubstrThrowsIndexOOB is BytesTest {
    function testImpl() internal {
        bytes memory bts = new bytes(0);
        bts.substr(1);
    }
}

/************************** substr with length ***************************/

contract TestBytesSubstrWithLen is BytesTest {
    function testImpl() internal {
        bytes memory bts = hex"8899aabbccddeeff8899aabbccddeeff8899aabbccddeeff8899aabbccddeeff8899aabbccddeeff8899aabbccddeeff8899aabbccddeeff8899aabbccddeeff8899aabbccddeeffaabb";
        var cpy = bts.substr(7, 12);
        var sdp = Memory.dataPtr(bts);
        var cdp = Memory.dataPtr(cpy);
        assert(cpy.length == 12);
        assert(Memory.equals(sdp + 7, cdp, 12));
    }
}


contract TestBytesSubstrWithLenFull is BytesTest {
    function testImpl() internal {
        bytes memory bts = hex"8899aabbccddeeff8899aabbccddeeff8899aabbccddeeff8899aabbccddeeff8899aabbccddeeff8899aabbccddeeff8899aabbccddeeff8899aabbccddeeff8899aabbccddeeffaabb";
        var cpy = bts.substr(0, bts.length);
        var sdp = Memory.dataPtr(bts);
        var cdp = Memory.dataPtr(cpy);
        assert(cpy.length == bts.length);
        assert(Memory.equals(sdp, cdp, bts.length));
    }
}


contract TestBytesSubstrWithLenEmptyBytes is BytesTest {
    function testImpl() internal {
        bytes memory bts = hex"8899aabbccddeeff8899aabbccddeeff8899aabbccddeeff8899aabbccddeeff8899aabbccddeeff8899aabbccddeeff8899aabbccddeeff8899aabbccddeeff8899aabbccddeeffaabb";
        var cpy = bts.substr(0, 0);
        assert(cpy.length == 0);
    }
}


contract TestBytesSubstrWithLenDoesNotMutate is BytesTest {
    function testImpl() internal {
        bytes memory bts = hex"8899aabbccddeeff8899aabbccddeeff8899aabbccddeeff8899aabbccddeeff8899aabbccddeeff8899aabbccddeeff8899aabbccddeeff8899aabbccddeeff8899aabbccddeeffaabb";
        bytes memory btsEq = hex"8899aabbccddeeff8899aabbccddeeff8899aabbccddeeff8899aabbccddeeff8899aabbccddeeff8899aabbccddeeff8899aabbccddeeff8899aabbccddeeff8899aabbccddeeffaabb";
        var btsAddr = Memory.ptr(bts);
        bts.substr(4, 21);
        assert(Memory.ptr(bts) == btsAddr);
        assert(bts.equals(btsEq));
    }
}


contract TestBytesSubstrWithLenThrowsIndexOOB is BytesTest {
    function testImpl() internal {
        bytes memory bts = new bytes(0);
        bts.substr(1, 0);
    }
}


contract TestBytesSubstrWithLenThrowsIndexPlusLengthOOB is BytesTest {
    function testImpl() internal {
        bytes memory bts = new bytes(1);
        bts.substr(0, 2);
    }
}

/************************** Concat ***************************/

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

/************************** bytes32 substr ***************************/

contract TestBytesBytes32Substr is BytesTest {
    function testImpl() internal {
        bytes32 b = 0x0123456789abcdef0123456789abcdef0123456789abcdef0123456789abcdef;
        bytes32 b4 = 0x89abcdef0123456789abcdef0123456789abcdef0123456789abcdef00000000;
        bytes32 b11 = 0x6789abcdef0123456789abcdef0123456789abcdef0000000000000000000000;
        bytes32 b23 = 0xef0123456789abcdef0000000000000000000000000000000000000000000000;
        bytes32 b31 = 0xef00000000000000000000000000000000000000000000000000000000000000;
        assert(b.substr(0) == b);
        assert(b.substr(4) == b4);
        assert(b.substr(11) == b11);
        assert(b.substr(23) == b23);
        assert(b.substr(31) == b31);
    }
}


contract TestBytesBytes32SubstrThrowsIndexOOB is BytesTest {
    function testImpl() internal {
        bytes32(0).substr(32);
    }
}

/************************** substr with length ***************************/

contract TestBytesBytes32SubstrWithLen is BytesTest {
    function testImpl() internal {
        bytes32 b = 0x0123456789abcdef0123456789abcdef0123456789abcdef0123456789abcdef;
        bytes32 b4L5 = 0x89abcdef01000000000000000000000000000000000000000000000000000000;
        bytes32 b11L12 = 0x6789abcdef0123456789abcd0000000000000000000000000000000000000000;
        bytes32 b23L2 = 0xef01000000000000000000000000000000000000000000000000000000000000;
        bytes32 b31L1 = 0xef00000000000000000000000000000000000000000000000000000000000000;
        assert(b.substr(0, 32) == b);
        assert(b.substr(4, 5) == b4L5);
        assert(b.substr(11, 12) == b11L12);
        assert(b.substr(23, 2) == b23L2);
        assert(b.substr(31, 1) == b31L1);
    }
}


contract TestBytesBytes32SubstrWithLenThrowsIndexOOB is BytesTest {
    function testImpl() internal {
        bytes32(0).substr(32, 0);
    }
}


contract TestBytesBytes32SubstrWithLenThrowsIndexPlusLengthOOB is BytesTest {
    function testImpl() internal {
        /* solhint-disable no-unused-vars */
        bytes memory bts = new bytes(1);
        bytes32(0).substr(4, 29);
        /* solhint-enable no-unused-vars */
    }
}

/******************* bytes32 toBytes ******************/

contract TestBytesBytes32ToBytesHighOrder is BytesTest {
    function testImpl() internal {
        var bts = bytes32("abc").toBytes();
        bytes memory btsExpctd = hex"6162630000000000000000000000000000000000000000000000000000000000";
        assert(bts.equals(btsExpctd));
    }
}


contract TestBytesBytes32ToBytesLowOrder is BytesTest {
    function testImpl() internal {
        var bts = bytes32(0x112233).toBytes();
        bytes memory btsExpctd = hex"0000000000000000000000000000000000000000000000000000000000112233";
        assert(bts.equals(btsExpctd));
    }
}


contract TestBytesBytes32ToBytesZero is BytesTest {
    function testImpl() internal {
        var bts = B32_ZERO.toBytes();
        bytes memory btsExp = new bytes(32);
        assert(bts.equals(btsExp));
    }
}

/******************* bytes32 toBytes with length ******************/

contract TestBytesBytes32ToBytesWithLenHighOrder is BytesTest {
    function testImpl() internal {
        var bts = bytes32("abc").toBytes(2);
        string memory str = "ab";
        assert(bts.equals(bytes(str)));
    }
}


contract TestBytesBytes32ToBytesWithLenLowOrder is BytesTest {
    function testImpl() internal {
        var bts = bytes32(0x112233).toBytes(31);
        bytes memory btsExpctd = hex"00000000000000000000000000000000000000000000000000000000001122";
        assert(bts.equals(btsExpctd));
    }
}


contract TestBytesBytes32ToBytesWithLenThrowsLenOOB is BytesTest {
    function testImpl() internal {
        bytes32(0).toBytes(33);
    }
}

/******************* address toBytes ******************/

contract TestBytesAddressToBytes is BytesTest {
    function testImpl() internal {
        var bts = address(0x0123456789012345678901234567890123456789).toBytes();
        bytes memory btsExpctd = hex"0123456789012345678901234567890123456789";
        assert(bts.equals(btsExpctd));
    }
}

/******************* uint toBytes ******************/

contract TestBytesUintToBytes is BytesTest {
    function testImpl() internal {
        uint n = 0x12345678;
        var bts = n.toBytes();
        bytes memory btsExpctd = hex"0000000000000000000000000000000000000000000000000000000012345678";
        assert(bts.equals(btsExpctd));
    }
}

/******************* uint toBytes with bitsize ******************/

contract TestBytesUintToBytesWithBitsizeZero is BytesTest {
    function testImpl() internal {
        var bts = uint(0).toBytes(256);
        bytes memory btsExpctd = new bytes(32);
        assert(bts.equals(btsExpctd));
    }
}


contract TestBytesUintToBytesWithBitsize is BytesTest {
    function testImpl() internal {
        uint n = 0x12345678;
        var bts = n.toBytes(32);
        bytes memory btsExpctd = hex"12345678";
        assert(bts.equals(btsExpctd));
    }
}


contract TestBytesUintToBytesWithBitsizeThrowsBitsizeLow is BytesTest {
    function testImpl() internal {
        uint(0).toBytes(0);
    }
}


contract TestBytesUintToBytesWithBitsizeThrowsBitsizeHigh is BytesTest {
    function testImpl() internal {
        uint(0).toBytes(264);
    }
}


contract TestBytesUintToBytesWithBitsizeThrowsBitsizeNotMultipleOf8 is BytesTest {
    function testImpl() internal {
        uint(0).toBytes(15);
    }
}

/******************* boolean toBytes ******************/

contract TestBytesBooleanToBytes is BytesTest {
    function testImpl() internal {
        bytes memory btsTrue = hex"01";
        bytes memory btsFalse = hex"00";
        assert(true.toBytes().equals(btsTrue));
        assert(false.toBytes().equals(btsFalse));
    }
}

/******************* bytes32 highest/lowest byte set ******************/

contract TestBytesBytes32HighestByteSetWithAllLowerSet is BytesTest {
    function testImpl() internal {
        for (uint8 i = 0; i < 32; i++) {
            assert(bytes32(ONES << 8*i).highestByteSet() == 31 - i);
        }
    }
}


contract TestBytesBytes32HighestByteSetWithSingleByte is BytesTest {
    function testImpl() internal {
        for (uint8 i = 0; i < 32; i++) {
            assert(bytes32(ONE << 8*i).highestByteSet() == 31 - i);
        }
    }
}


contract TestBytesBytes32HighestByteSetThrowsBytes32IsZero is BytesTest {
    function testImpl() internal {
        B32_ZERO.highestByteSet();
    }
}


contract TestBytesBytes32LowestByteSetWithAllHigherSet is BytesTest {
    function testImpl() internal {
        for (uint8 i = 0; i < 31; i++) {
            assert(bytes32(ONES >> 8*i).lowestByteSet() == i);
        }
    }
}


contract TestBytesBytes32LowestByteSetWithSingleByte is BytesTest {
    function testImpl() internal {
        for (uint8 i = 0; i < 32; i++) {
            assert(bytes32(ONE << 8*i).lowestByteSet() == 31 - i);
        }
    }
}


contract TestBytesBytes32LowestByteSetThrowsBytes32IsZero is BytesTest {
    function testImpl() internal {
        B32_ZERO.lowestByteSet();
    }
}

/******************* uint highest/lowest byte set ******************/

contract TestBytesUintHighestByteSetWithAllLowerSet is BytesTest {
    function testImpl() internal {
        for (uint8 i = 0; i < 31; i++) {
            assert((ONES >> 8*i).highestByteSet() == (31 - i));
        }
    }
}


contract TestBytesUintHighestByteSetWithSingleByte is BytesTest {
    function testImpl() internal {
        for (uint8 i = 0; i < 32; i++) {
            assert((ONE << 8*i).highestByteSet() == i);
        }
    }
}


contract TestBytesUintHighestByteSetThrowsBytes32IsZero is BytesTest {
    function testImpl() internal {
        ZERO.highestByteSet();
    }
}


contract TestBytesUintLowestByteSetWithAllHigherSet is BytesTest {
    function testImpl() internal {
        for (uint8 i = 0; i < 32; i++) {
            assert((ONES << 8*i).lowestByteSet() == i);
        }
    }
}


contract TestBytesUintLowestByteSetWithSingleByte is BytesTest {
    function testImpl() internal {
        for (uint8 i = 0; i < 32; i++) {
            assert((ONE << 8*i).lowestByteSet() == i);
        }
    }
}


contract TestBytesUintLowestByteSetThrowsBytes32IsZero is BytesTest {
    function testImpl() internal {
        ZERO.lowestByteSet();
    }
}
/* solhint-enable max-line-length */