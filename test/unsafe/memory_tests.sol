pragma solidity ^0.4.15;

import {STLTest} from "../STLTest.sol";
import {Memory} from "../../src/unsafe/Memory.sol";

/*******************************************************/

contract MemoryTest is STLTest {}

/*******************************************************/

contract TestMemoryMemEqualsZeroLength is MemoryTest {
    function testImpl() internal {
        assert(Memory.equals(0, 0, 0));
    }
}


contract TestMemoryEqualsItselfDifferentAddresses is MemoryTest {
    function testImpl() internal {
        bytes memory bts = hex"0102030405060708090a0b0c0d0e0f0102030405060708090a0b0c0d0e0f0102030405060708090a0b0c0d0e0f0102030405060708090a0b0c0d0e0f0102030405060708090a0b0c0d0e0f0102030405060708090a0b0c0d0e0f0102030405060708090a0b0c0d0e0f0102030405060708090a0b0c0d0e0f0102030405060708090a0b0c0d0e0f0102030405060708090a0b0c0d0e0f0102030405060708090a0b0c0d0e0f0102030405060708090a0b0c0d0e0f0102030405060708090a0b0c0d0e0f0102030405060708090a0b0c0d0e0f0102030405060708090a0b0c0d0e0f0102030405060708090a0b0c0d0e0f0102030405060708090a0b0c0d0e0f0102030405060708090a0b0c0d0e0f0102030405060708090a0b0c0d0e0f0102030405060708090a0b0c0d0e0f0102030405060708090a0b0c0d0e0f0102030405060708090a0b0c0d0e0f0102030405060708090a0b0c0d0e0f0102030405060708090a0b0c0d0e0f0102030405060708090a0b0c0d0e0f0102030405060708090a0b0c0d0e0f0102030405060708090a0b0c0d0e0f0102030405060708090a0b0c0d0e0f0102030405060708090a0b0c0d0e0f0102030405060708090a0b0c0d0e0f0102030405060708090a0b0c0d0e0f0102030405060708090a0b0c0d0e0f0102030405060708090a0b0c0d0e0f0102030405060708090a0b0c0d0e0f0102030405060708090a0b0c0d0e0f0102030405060708090a0b0c0d0e0f0102030405060708090a0b0c0d0e0f0102030405060708090a0b0c0d0e0f0102030405060708090a0b0c0d0e0f0102030405060708090a0b0c0d0e0f0102030405060708090a0b0c0d0e0f0102030405060708090a0b0c0d0e0f0102030405060708090a0b0c0d0e0f0102030405060708090a0b0c0d0e0f0102030405060708090a0b0c0d0e0f0102030405060708090a0b0c0d0e0f0102030405060708090a0b0c0d0e0f0102030405060708090a0b0c0d0e0f0102030405060708090a0b0c0d0e0f0102030405060708090a0b0c0d0e0f0102030405060708090a0b0c0d0e0f0102030405060708090a0b0c0d0e0f0102030405060708090a0b0c0d0e0f0102030405060708090a0b0c0d0e0f0102030405060708090a0b0c0d0e0f0102030405060708090a0b0c0d0e0f0102030405060708090a0b0c0d0e0f0102030405060708090a0b0c0d0e0f";
        for (uint i = 0; i < 10; i++) {
            assert(Memory.equals(0x15*i, 0x15*i, 50));
        }
    }
}


contract TestMemoryEqualsItselfDifferentLengths is MemoryTest {
    function testImpl() internal {
        bytes memory bts = hex"0102030405060708090a0b0c0d0e0f0102030405060708090a0b0c0d0e0f0102030405060708090a0b0c0d0e0f0102030405060708090a0b0c0d0e0f0102030405060708090a0b0c0d0e0f0102030405060708090a0b0c0d0e0f0102030405060708090a0b0c0d0e0f0102030405060708090a0b0c0d0e0f0102030405060708090a0b0c0d0e0f0102030405060708090a0b0c0d0e0f0102030405060708090a0b0c0d0e0f0102030405060708090a0b0c0d0e0f0102030405060708090a0b0c0d0e0f0102030405060708090a0b0c0d0e0f0102030405060708090a0b0c0d0e0f0102030405060708090a0b0c0d0e0f0102030405060708090a0b0c0d0e0f0102030405060708090a0b0c0d0e0f0102030405060708090a0b0c0d0e0f0102030405060708090a0b0c0d0e0f0102030405060708090a0b0c0d0e0f0102030405060708090a0b0c0d0e0f0102030405060708090a0b0c0d0e0f0102030405060708090a0b0c0d0e0f0102030405060708090a0b0c0d0e0f0102030405060708090a0b0c0d0e0f0102030405060708090a0b0c0d0e0f0102030405060708090a0b0c0d0e0f0102030405060708090a0b0c0d0e0f0102030405060708090a0b0c0d0e0f0102030405060708090a0b0c0d0e0f0102030405060708090a0b0c0d0e0f0102030405060708090a0b0c0d0e0f0102030405060708090a0b0c0d0e0f0102030405060708090a0b0c0d0e0f0102030405060708090a0b0c0d0e0f0102030405060708090a0b0c0d0e0f0102030405060708090a0b0c0d0e0f0102030405060708090a0b0c0d0e0f0102030405060708090a0b0c0d0e0f0102030405060708090a0b0c0d0e0f0102030405060708090a0b0c0d0e0f0102030405060708090a0b0c0d0e0f0102030405060708090a0b0c0d0e0f0102030405060708090a0b0c0d0e0f0102030405060708090a0b0c0d0e0f0102030405060708090a0b0c0d0e0f0102030405060708090a0b0c0d0e0f0102030405060708090a0b0c0d0e0f0102030405060708090a0b0c0d0e0f0102030405060708090a0b0c0d0e0f0102030405060708090a0b0c0d0e0f0102030405060708090a0b0c0d0e0f0102030405060708090a0b0c0d0e0f0102030405060708090a0b0c0d0e0f0102030405060708090a0b0c0d0e0f0102030405060708090a0b0c0d0e0f0102030405060708090a0b0c0d0e0f";
        for (uint i = 0; i < 10; i++) {
            assert(Memory.equals(0x40, 0x40, 30*i));
        }
    }
}


contract TestMemoryNotEqual is MemoryTest {
    function testImpl() internal {
        bytes memory bts = hex"0102030405060708090a0b";
        uint btsAddr;
        assembly {
            btsAddr := bts
        }
        assert(!Memory.equals(btsAddr, btsAddr + 0x20, 10));
    }
}


contract TestMemoryNotEqualCommutative is MemoryTest {
    function testImpl() internal {
        bytes memory bts = hex"0102030405060708090a0b";
        uint btsAddr;
        assembly {
            btsAddr := bts
        }
        assert(!Memory.equals(btsAddr, btsAddr + 0x20, 10) && !Memory.equals(btsAddr + 20, btsAddr, 10));
    }
}


contract TestMemoryEqualsRefItself is MemoryTest {
    function testImpl() internal {
        var m = Memory.allocate(15);
        assert(Memory.equalsRef(m, m));
    }
}


contract TestMemoryEqualsRefBothLengthZero is MemoryTest {
    function testImpl() internal {
        var m0 = Memory.allocate(0);
        var m1 = Memory.allocate(0);
        assert(!Memory.equalsRef(m0, m1));
    }
}


contract TestMemoryEqualsRefNonEqualCommutative is MemoryTest {
    function testImpl() internal {
        var m0 = Memory.allocate(15);
        var m1 = Memory.allocate(24);
        assert(!Memory.equalsRef(m0, m1) && !Memory.equalsRef(m1, m0));
    }
}


contract TestMemoryUnsafeAllocate is MemoryTest {
    function testImpl() internal {
        uint cur;
        assembly {
            cur := mload(0x40)
        }
        var mem = Memory.unsafeAllocate(45);
        assert(mem == cur);
        uint newCur;
        assembly {
            newCur := mload(0x40)
        }
        assert(newCur == cur + 45);
    }
}


contract TestMemoryAllocate is MemoryTest {
    function testImpl() internal {
        uint cur;
        assembly {
            cur := mload(0x40)
        }
        cur += 0x40; // Array itself requires 2 words.
        var mem = Memory.allocate(45);
        assert(mem._len == 45);
        assert(mem._ptr == cur);
        uint newCur;
        assembly {
            newCur := mload(0x40)
        }
        assert(newCur == cur + 45);
    }
}


contract TestMemoryIsNull is MemoryTest {
    function testImpl() internal {
        Memory.Array memory mem;
        assert(Memory.isNull(mem));
    }
}


contract TestMemoryUnsafeCopy is MemoryTest {
    function testImpl() internal {
        bytes memory bts = hex"ffaaffaaffaaffaaffaaffaaffaaffffaaffaaffaaffaaffaaffaaffaaffffaaffaaffaaffaaffaaffaaffaaff";
        var src = Memory.fromBytes(bts);
        var dest = Memory.allocate(45);
        Memory.unsafeCopy(src._ptr, dest._ptr, src._len);
        assert(Memory.equals(dest._ptr, dest._len, bts));
        assert(src._ptr != dest._ptr);
    }
}


contract TestMemoryUnsafeCopyLengthZero is MemoryTest {
    function testImpl() internal {
        bytes memory bts = new bytes(0);
        bytes memory bts2 = hex"ffaa";
        var src = Memory.fromBytes(bts);
        var dest = Memory.fromBytes(bts2);
        Memory.unsafeCopy(src._ptr, dest._ptr, 0);
        assert(bts2[0] == hex"ff");
        assert(bts2[1] == hex"aa");
    }
}


contract TestMemoryUnsafeCopyDoesNotChangeSrcMem is MemoryTest {
    function testImpl() internal {
        bytes memory bts = hex"ffaaffaaffaaffaaffaaffaaffaaffffaaffaaffaaffaaffaaffaaffaaffffaaffaaffaaffaaffaaffaaffaaff";
        var src = Memory.fromBytes(bts);
        var dest = Memory.allocate(45);
        Memory.unsafeCopy(src._ptr, dest._ptr, src._len);
        assert(Memory.equals(src._ptr, src._len, bts));
    }
}


contract TestMemoryCopy is MemoryTest {
    function testImpl() internal {
        bytes memory bts = hex"ffaaffaaffaaffaaffaaffaaffaaffffaaffaaffaaffaaffaaffaaffaaffffaaffaaffaaffaaffaaffaaffaaff";
        var src = Memory.fromBytes(bts);
        var dest = Memory.copy(src);
        assert(Memory.equals(dest._ptr, dest._len, bts));
        assert(!Memory.equalsRef(src, dest));
    }
}


contract TestMemoryCopyDoesNotMutateSrcRef is MemoryTest {
    function testImpl() internal {
        var src = Memory.allocate(34);
        uint srclen = src._len;
        uint srcptr = src._ptr;
        Memory.copy(src);
        assert(src._len == srclen);
        assert(src._ptr == srcptr);
    }
}


contract TestMemoryCopyDoesNotMutateSrcMem is MemoryTest {
    function testImpl() internal {
        bytes memory bts = hex"ffaaffaaffaaffaaffaaffaaffaaffffaaffaaffaaffaaffaaffaaffaaffffaaffaaffaaffaaffaaffaaffaaff";
        var src = Memory.fromBytes(bts);
        Memory.copy(src);
        assert(Memory.equals(src._ptr, src._len, bts));
    }
}


contract TestMemoryCopyThrowsSrcIsNull is MemoryTest {
    function testImpl() internal {
        Memory.Array memory src;
        Memory.copy(src);
    }
}


contract TestMemoryCopyToPreAllocated is MemoryTest {
    function testImpl() internal {
        bytes memory bts = hex"ffaaffaaffaaffaaffaaffaaffaaffffaaffaaffaaffaaffaaffaaffaaffffaaffaaffaaffaaffaaffaaffaaff";
        var src = Memory.fromBytes(bts);
        var dest = Memory.allocate(45);
        Memory.copy(src, dest);
        assert(Memory.equals(dest._ptr, dest._len, bts));
    }
}


contract TestMemoryCopyToPreAllocatedDoesNotMutateSrcRef is MemoryTest {
    function testImpl() internal {
        var src = Memory.allocate(34);
        uint srclen = src._len;
        uint srcptr = src._ptr;
        Memory.copy(src, Memory.allocate(34));
        assert(src._len == srclen);
        assert(src._ptr == srcptr);
    }
}


contract TestMemoryCopyToPreAllocatedDoesNotMutateSrcMem is MemoryTest {
    function testImpl() internal {
        bytes memory bts = hex"ffaaffaaffaaffaaffaaffaaffaaffffaaffaaffaaffaaffaaffaaffaaffffaaffaaffaaffaaffaaffaaffaaff";
        var src = Memory.fromBytes(bts);
        var dest = Memory.allocate(bts.length);
        Memory.copy(src, dest);
        assert(Memory.equals(src._ptr, src._len, bts));
    }
}


contract TestMemoryCopyToPreAllocatedThrowsSrcIsNull is MemoryTest {
    function testImpl() internal {
        var src = Memory.Array(0 ,0);
        var dest = Memory.allocate(43);
        Memory.copy(src, dest);
    }
}


contract TestMemoryCopyToPreAllocatedThrowsDestIsNull is MemoryTest {
    function testImpl() internal {
        var src = Memory.allocate(12);
        var dest = Memory.Array(0 ,0);
        Memory.copy(src, dest);
    }
}


contract TestMemoryCopyToPreAllocatedThrowsDifferentLength is MemoryTest {
    function testImpl() internal {
        var src = Memory.allocate(25);
        var dest = Memory.allocate(73);
        Memory.copy(src, dest);
    }
}


contract TestMemoryFromBytes is MemoryTest {
    function testImpl() internal {
        bytes memory bts = hex"0102030405060708090a0b";
        var mem = Memory.fromBytes(bts);
        assert(mem._len == bts.length);
        uint btsDataAddr;
        assembly {
            btsDataAddr := add(bts, 0x20)
        }
        assert(mem._ptr == btsDataAddr);
    }
}


contract TestMemoryFromString is MemoryTest {
    function testImpl() internal {
        string memory str = "Terry A. Davis";
        var mem = Memory.fromString(str);
        assert(mem._len == bytes(str).length);
        uint strDataAddr;
        assembly {
            strDataAddr := add(str, 0x20)
        }
        assert(mem._ptr == strDataAddr);
    }
}


contract TestMemoryFromUint is MemoryTest {
    function testImpl() internal {
        uint n = 5525;
        var mem = Memory.fromUint(n);
        assert(mem._len == 32);
        uint ptr = mem._ptr;
        uint atMem;
        assembly {
            atMem := mload(ptr)
        }
        assert(atMem == n);
    }
}


contract TestMemoryFromBytes32 is MemoryTest {
    function testImpl() internal {
        bytes32 b32 = 0xaabbccddeeff;
        var mem = Memory.fromBytes32(b32);
        assert(mem._len == 32);
        uint ptr = mem._ptr;
        bytes32 atMem;
        assembly {
            atMem := mload(ptr)
        }
        assert(atMem == b32);
    }
}


contract TestMemoryToBytes is MemoryTest {
    function testImpl() internal {
        bytes memory bts = hex"ffaaffaaffaaffaaffaaffaaffaaff";
        var mem = Memory.fromBytes(bts);
        var bts2 = Memory.toBytes(mem);
        assert(bts.length == bts.length);
        for(uint i = 0; i < bts.length; i++) {
            assert(bts[i] == bts2[i]);
        }
    }
}


contract TestMemoryToBytesThrowsMemIsNull is MemoryTest {
    function testImpl() internal {
        Memory.Array memory mem;
        Memory.toBytes(mem);
    }
}


contract TestMemoryToString is MemoryTest {
    function testImpl() internal {
        string memory str = "Terry A. Davis";
        var mem = Memory.fromString(str);
        var str2 = Memory.toString(mem);
        var bts = bytes(str);
        var bts2 = bytes(str2);
        assert(bts.length == bts.length);
        for(uint i = 0; i < bts.length; i++) {
            assert(bts[i] == bts2[i]);
        }
    }
}


contract TestMemoryToStringThrowsMemIsNull is MemoryTest {
    function testImpl() internal {
        Memory.Array memory mem;
        Memory.toString(mem);
    }
}


contract TestMemoryToUint is MemoryTest {
    function testImpl() internal {
        uint n = 12345;
        var mem = Memory.fromUint(n);
        var n2 = Memory.toUint(mem);
        assert(n == n2);
    }
}


contract TestMemoryToUintLessThen32Bytes is MemoryTest {
    function testImpl() internal {
        uint n = 0x1122334455667788;
        var mem = Memory.allocate(32);
        var ptr = mem._ptr;
        assembly {
            mstore(ptr, n)
        }
        mem._len = 4;
        var n2 = Memory.toUint(mem);
        assert(0x55667788 == n2);
    }
}


contract TestMemoryToUintThrowsMemNull is MemoryTest {
    function testImpl() internal {
        Memory.Array memory mem;
        Memory.toUint(mem);
    }
}


contract TestMemoryToUintThrowsMemLenIsZero is MemoryTest {
    function testImpl() internal {
        Memory.Array memory mem  = Memory.Array(0x60, 0);
        Memory.toUint(mem);
    }
}


contract TestMemoryToUintThrowsMemLenGreaterThan32 is MemoryTest {
    function testImpl() internal {
        Memory.Array memory mem  = Memory.Array(0x60, 35);
        Memory.toUint(mem);
    }
}

contract TestMemoryToBytes32 is MemoryTest {
    function testImpl() internal {
        bytes32 b32 = 0x1122334455;
        var mem = Memory.fromBytes32(b32);
        var b322 = Memory.toBytes32(mem);
        assert(b32 == b322);
    }
}


contract TestMemoryToBytes32ThrowsMemLenNot32 is MemoryTest {
    function testImpl() internal {
        Memory.Array memory mem  = Memory.Array(0x60, 25);
        Memory.toBytes32(mem);
    }
}