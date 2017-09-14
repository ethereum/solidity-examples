pragma solidity ^0.4.15;


library Memory {

    /* A MemoryArray contains a pointer to a memory address, and
     * a length.
     * WARNING - don't manipulate these fields directly, as they make
     * up a section of memory that is guaranteed to be allocated. Additionally,
     * MemoryArray should not be created directly, but only gotten through
     * the functions in this library.
     */
    struct MemoryArray {
        uint _len;
        uint _ptr;
    }

    // Allocates 'size' bytes of memory and returns a MemoryArray object.
    function allocate(uint numBytes) constant internal returns (MemoryArray memory mArr) {
        mArr._len = numBytes;
        mArr._ptr = unsafeAllocate(numBytes);
    }

    // NOTE: This does not free the memory because that is not how EVM memory works.
    function destroy(MemoryArray memory self) internal constant {
        self._len = 0;
        self._ptr = 0;
    }

    // Copy a memory array. This allocates new memory and adds it
    function copy(MemoryArray memory self) constant internal returns (MemoryArray memory dest) {
        require(!isNull(self));
        dest = allocate(self._len);
        uint srcP = self._ptr;
        uint destP = dest._ptr;
        unsafeCopy(srcP, destP, self._len);
    }

    // Copy a memory array 'src' into a pre-allocated array 'dest'
    function copy(MemoryArray memory self, MemoryArray memory dest) constant internal {
        require(!isNull(self) && !isNull(dest));
        uint srcP = self._ptr;
        uint destP = dest._ptr;
        unsafeCopy(srcP, destP, self._len);
    }

    function equals(MemoryArray memory self, MemoryArray memory other) internal constant returns (bool equal) {
        if (self._len != other._len) {
            return false;
        }
        return equals(self._ptr, other._ptr, self._len);
    }

    function refEquals(MemoryArray memory self, MemoryArray memory other) internal constant returns (bool equal) {
        equal = self._len == other._len && self._ptr == other._ptr;
    }

    function isNull(MemoryArray memory self) internal constant returns (bool) {
        return self._ptr == 0 && self._len == 0;
    }

    function equals(uint addr, uint addr2, uint len) internal constant returns (bool equal) {
        // Compare word-length chunks while possible
        for (; len >= 32; len -= 32) {
            assembly {
                equal := eq(mload(addr), mload(addr2))
            }
            if (!equal) {
                return false;
            }
            addr += 32;
            addr2 += 32;
        }
        // Remaining bytes
        uint mask = 256 ** (32 - len) - 1;
        assembly {
            equal := eq( and(mload(addr), mask), and(mload(addr2), mask) )
        }
    }

    function equals(uint addr, uint len, bytes memory bts) internal constant returns (bool equal) {
        uint addr2;
        assembly {
            addr2 := add(bts, 0x20)
        }
        for (; len >= 32; len -= 32) {
            assembly {
                equal := eq(mload(addr), mload(addr2))
            }
            if (!equal) {
                return false;
            }
            addr += 32;
            addr2 += 32;
        }
        // Remaining bytes
        uint mask = 256 ** (32 - len) - 1;
        assembly {
            equal := eq( and(mload(addr), mask), and(mload(addr2), mask) )
        }
    }

    // Allocates 'numBytes' bytes of memory and returns a pointer to the starting address.
    // Additionally, all allocated bytes are equal to 0.
    // UNSAFE because it does not produce a MemoryArray object that couples the
    // address with the number of allocated bytes. This has to be tracked manually.
    function unsafeAllocate(uint numBytes) constant internal returns (uint addr) {
        // Take the current value of the free memory pointer, and update.
        assembly {
            addr := mload(0x40)
            mstore(0x40, add(addr, numBytes))
        }
    }

    // Copies 'len' bytes of memory from address 'src' to address 'dest'
    // UNSAFE because there is no checking that the destination has been
    // properly allocated.
    function unsafeCopy(uint src, uint dest, uint len) constant internal {
        // Copy word-length chunks while possible
        for (; len >= 32; len -= 32) {
            assembly {
                mstore(dest, mload(src))
            }
            dest += 32;
            src += 32;
        }

        // Copy remaining bytes
        uint mask = 256 ** (32 - len) - 1;
        assembly {
            let srcpart := and(mload(src), not(mask))
            let destpart := and(mload(dest), mask)
            mstore(dest, or(destpart, srcpart))
        }
    }

    /******************** from types **********************/

    function fromBytes(bytes memory bts) internal constant returns (MemoryArray memory mArr) {
        uint addr;
        uint len;
        assembly {
            len := mload(bts)
            addr := add(bts, 0x20)
        }
        mArr._len = len;
        mArr._ptr = addr;
    }

    function fromString(string memory str) internal constant returns (MemoryArray memory mArr) {
        uint addr;
        uint len;
        assembly {
            len := mload(str)
            addr := add(str, 0x20)
        }
        mArr._len = len;
        mArr._ptr = addr;
    }

    function fromUint(uint n) internal constant returns (MemoryArray memory mArr) {
        mArr = allocate(32);
        uint ptr = mArr._ptr;
        assembly {
            mstore(ptr, n)
        }
    }

    function fromInt(int n) internal constant returns (MemoryArray memory mArr) {
        mArr = allocate(32);
        uint ptr = mArr._ptr;
        assembly {
            mstore(ptr, n)
        }
    }

    function fromBytes32(bytes32 b32) internal constant returns (MemoryArray memory mArr) {
        mArr = allocate(32);
        uint ptr = mArr._ptr;
        assembly {
            mstore(ptr, b32)
        }
    }

    /******************** to types **********************/

    function toBytes(MemoryArray memory self) internal constant returns (bytes memory bts) {
        require(!isNull(self));
        if (self._len == 0) {
            return;
        }
        bts = new bytes(self._len);
        uint btsptr;
        assembly {
            btsptr := add(bts, 0x20)
        }
        unsafeCopy(self._ptr, btsptr, self._len);
    }

    function toString(MemoryArray memory self) internal constant returns (string memory str) {
        require(!isNull(self));
        if (self._len == 0) {
            return;
        }
        str = new string(self._len);
        uint strptr;
        assembly {
            strptr := add(str, 0x20)
        }
        unsafeCopy(self._ptr, strptr, self._len);
    }

    function toUint(MemoryArray memory mArr) internal constant returns (uint n) {
        require(mArr._len == 32);
        uint ptr = mArr._ptr;
        assembly {
            n := mload(ptr)
        }
    }

    function toInt(MemoryArray memory mArr) internal constant returns (int n) {
        require(mArr._len == 32);
        uint ptr = mArr._ptr;
        assembly {
            n := mload(ptr)
        }
    }

    function toBytes32(MemoryArray memory mArr) internal constant returns (bytes32 b32) {
        require(mArr._len == 32);
        uint ptr = mArr._ptr;
        assembly {
            b32 := mload(ptr)
        }
    }

}