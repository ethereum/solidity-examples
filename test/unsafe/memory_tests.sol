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
        assert(newCur - cur == 45);
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
        Memory.unsafeCopy(dest._ptr, src._ptr, src._len);
        assert(Memory.equals(dest._ptr, src._ptr, src._len));
    }
}


contract TestMemoryUnsafeCopyLengthZero is MemoryTest {
    function testImpl() internal {
        bytes memory bts = new bytes(0);
        bytes memory bts2 = hex"ffaa";
        var src = Memory.fromBytes(bts);
        var dest = Memory.fromBytes(bts2);
        Memory.unsafeCopy(dest._ptr, src._ptr, 0);
        assert(bts2[0] == hex"ff");
        assert(bts2[1] == hex"aa");
    }
}


contract TestMemoryCopy is MemoryTest {
    function testImpl() internal {
        bytes memory bts = hex"ffaaffaaffaaffaaffaaffaaffaaffffaaffaaffaaffaaffaaffaaffaaffffaaffaaffaaffaaffaaffaaffaaff";
        var src = Memory.fromBytes(bts);
        var dest = Memory.copy(src);
        assert(Memory.equals(dest._ptr, src._ptr, src._len));
    }
}


contract TestMemoryCopyToPreAllocated is MemoryTest {
    function testImpl() internal {
        bytes memory bts = hex"ffaaffaaffaaffaaffaaffaaffaaffffaaffaaffaaffaaffaaffaaffaaffffaaffaaffaaffaaffaaffaaffaaff";
        var src = Memory.fromBytes(bts);
        var dest = Memory.allocate(45);
        Memory.copy(src, dest);
        assert(Memory.equals(dest._ptr, src._ptr, src._len));
    }
}