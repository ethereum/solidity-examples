pragma solidity ^0.4.16;
pragma experimental "v0.5.0";
pragma experimental "ABIEncoderV2";

import {STLTest} from "../STLTest.sol";
import {Memory} from "../../src/unsafe/Memory.sol";

/* solhint-disable max-line-length */
/* solhint-disable no-unused-vars */
/*********************** Base test contract ************************/

/* solhint-disable no-empty-blocks */
contract MemoryTest is STLTest {}
/* solhint-disable no-empty-blocks */

/*********************** Equality **************************/

contract TestMemoryEqualsZeroLength is MemoryTest {
    function testImpl() internal {
        assert(Memory.equals(0, 0, 0));
    }
}


contract TestMemoryEqualsItselfDifferentAddresses is MemoryTest {
    function testImpl() internal {
        /* solhint-disable no-unused-vars */
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
        assert(!Memory.equals(btsAddr, btsAddr + 0x20, 10) && !Memory.equals(btsAddr + 0x20, btsAddr, 10));
    }
}


contract TestMemoryEqualsBytesZeroLength is MemoryTest {
    function testImpl() internal {
        assert(Memory.equals(0, 0, new bytes(0)));
    }
}


contract TestMemoryEqualsThrowsBytesTooShort is MemoryTest {
    function testImpl() internal {
        bytes memory bts = new bytes(2);
        Memory.equals(0, 3, bts);
    }
}

/********************* Allocation and creating references **************************/

contract TestMemoryAllocate is MemoryTest {
    function testImpl() internal {
        uint cur;
        assembly {
            cur := mload(0x40)
        }
        var mem = Memory.allocate(45);
        assert(mem == cur);
        uint newCur;
        assembly {
            newCur := mload(0x40)
        }
        assert(newCur == cur + 45);
    }
}


contract TestMemoryAllocateZeroLength is MemoryTest {
    function testImpl() internal {
        uint cur;
        assembly {
            cur := mload(0x40)
        }
        var mem = Memory.allocate(0);
        assert(mem == cur);
        uint newCur;
        assembly {
            newCur := mload(0x40)
        }
        assert(newCur == cur);
    }
}


contract TestMemoryPtrBytes is MemoryTest {
    function testImpl() internal {
        bytes memory bts = hex"0102030405060708090a0b";
        var addr = Memory.ptr(bts);
        uint btsAddr;
        assembly {
            btsAddr := bts
        }
        assert(addr == btsAddr);
    }
}


contract TestMemoryDataPtrBytes is MemoryTest {
    function testImpl() internal {
        bytes memory bts = hex"0102030405060708090a0b";
        var addr = Memory.dataPtr(bts);
        uint btsDataAddr;
        assembly {
            btsDataAddr := add(bts, 0x20)
        }
        assert(addr == btsDataAddr);
    }
}


contract TestMemoryFromBytes is MemoryTest {
    function testImpl() internal {
        bytes memory bts = hex"0102030405060708090a0b";
        var (addr, len) = Memory.fromBytes(bts);
        assert(len == bts.length);
        uint btsDataAddr;
        assembly {
            btsDataAddr := add(bts, 0x20)
        }
        assert(addr == btsDataAddr);
    }
}

/********************* Copying **************************/

contract TestMemoryCopy is MemoryTest {
    function testImpl() internal {
        bytes memory bts = hex"ffaaffaaffaaffaaffaaffaaffaaffffaaffaaffaaffaaffaaffaaffaaffffaaffaaffaaffaaffaaffaaffaaff";
        var (src, len) = Memory.fromBytes(bts);
        var dest = Memory.allocate(len);
        Memory.copy(src, dest, len);
        assert(Memory.equals(dest, len, bts));
    }
}


contract TestMemoryCopyLengthZero is MemoryTest {
    function testImpl() internal {
        bytes memory bts = new bytes(0);
        bytes memory bts2 = hex"ffaa";
        var (src, ) = Memory.fromBytes(bts);
        var (dest, ) = Memory.fromBytes(bts2);
        Memory.copy(src, dest, 0);
        // Check that bts2 is still intact.
        assert(bts2[0] == hex"ff");
        assert(bts2[1] == hex"aa");
    }
}


contract TestMemoryCopyDoesNotChangeSrc is MemoryTest {
    function testImpl() internal {
        bytes memory bts = hex"ffaaffaaffaaffaaffaaffaaffaaffffaaffaaffaaffaaffaaffaaffaaffffaaffaaffaaffaaffaaffaaffaaff";
        var (src, len) = Memory.fromBytes(bts);
        var dest = Memory.allocate(len);
        Memory.copy(src, dest, len);
        assert(Memory.equals(src, len, bts));
    }
}

/********************* To types **************************/

contract TestMemoryToBytes is MemoryTest {
    function testImpl() internal {
        bytes memory bts = hex"ffaaffaaffaaffaaffaaffaaffaaff";
        var (addr, len) = Memory.fromBytes(bts);
        var bts2 = Memory.toBytes(addr, len);
        assert(bts2.length == bts.length);
        for (uint i = 0; i < bts.length; i++) {
            assert(bts[i] == bts2[i]);
        }
    }
}


contract TestMemoryToUint is MemoryTest {
    function testImpl() internal {
        uint n = 12345;
        var addr = Memory.allocate(32);
        assembly {
            mstore(addr, n)
        }
        var n2 = Memory.toUint(addr);
        assert(n == n2);
    }
}


contract TestMemoryToBytes32 is MemoryTest {
    function testImpl() internal {
        bytes32 b32 = 0x112233;
        var addr = Memory.allocate(32);
        assembly {
            mstore(addr, b32)
        }
        var res = Memory.toBytes32(addr);
        assert(res == b32);
    }
}

/*
contract TestMemoryToByte is MemoryTest {
    function testImpl() internal {
        bytes32 b32 = "abcdefghijklmnopabcdefghijklmnop";
        var addr = Memory.allocate(32);
        assembly {
            mstore(addr, b32)
        }
        for (uint8 i = 0; i < 32; i++) {
            var res = Memory.toByte(addr, i);
            assert(res == b32[i]);
        }
    }
}
*/
/* solhint-enable max-line-length */
/* solhint-enable no-unused-vars */