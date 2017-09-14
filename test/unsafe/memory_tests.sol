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
        cur += 0x40; // MemoryArray itself requires 2 words.
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


contract TestMemoryDestroy is MemoryTest {
    function testImpl() internal {
        var mem = Memory.allocate(1);
        Memory.destroy(mem);
        assert(mem._len == 0);
        assert(mem._ptr == 0);
    }
}


contract TestMemoryIsNull is MemoryTest {
    function testImpl() internal {
        Memory.MemoryArray memory mem;
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


contract TestMemoryCopy is MemoryTest {
    function testImpl() internal {
        bytes memory bts = hex"ffaaffaaffaaffaaffaaffaaffaaffffaaffaaffaaffaaffaaffaaffaaffffaaffaaffaaffaaffaaffaaffaaff";
        var src = Memory.fromBytes(bts);
        var dest = Memory.copy(src);
        assert(Memory.equals(dest._ptr, dest._len, bts));
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


contract TestMemoryFromInt is MemoryTest {
    function testImpl() internal {
        int n = -5525223;
        var mem = Memory.fromInt(n);
        assert(mem._len == 32);
        uint ptr = mem._ptr;
        int atMem;
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
        Memory.MemoryArray memory mem  = Memory.MemoryArray(0, 0);
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
        Memory.MemoryArray memory mem  = Memory.MemoryArray(0, 0);
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


contract TestMemoryToUintThrowsMemLenNot32 is MemoryTest {
    function testImpl() internal {
        Memory.MemoryArray memory mem  = Memory.MemoryArray(0x60, 25);
        Memory.toUint(mem);
    }
}


contract TestMemoryToInt is MemoryTest {
    function testImpl() internal {
        int n = -54321;
        var mem = Memory.fromInt(n);
        var n2 = Memory.toInt(mem);
        assert(n == n2);
    }
}


contract TestMemoryToIntThrowsMemLenNot32 is MemoryTest {
    function testImpl() internal {
        Memory.MemoryArray memory mem  = Memory.MemoryArray(0x60, 25);
        Memory.toInt(mem);
    }
}


contract TestMemoryToBytes32 is MemoryTest {
    function testImpl() internal {
        bytes32 b32 = 0x001122334455;
        var mem = Memory.fromBytes32(b32);
        var b322 = Memory.toBytes32(mem);
        assert(b32 == b322);
    }
}


contract TestMemoryToBytes32ThrowsMemLenNot32 is MemoryTest {
    function testImpl() internal {
        Memory.MemoryArray memory mem  = Memory.MemoryArray(0x60, 25);
        Memory.toBytes32(mem);
    }
}