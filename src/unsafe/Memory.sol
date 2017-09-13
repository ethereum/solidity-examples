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

    function fromBytes(bytes bts) internal constant returns (MemoryArray memory mArr) {
        uint addr;
        assembly {
            addr := add(bts, 0x20)
        }
        mArr._len = bts.length;
        mArr._ptr = addr;
    }

    function toBytes(MemoryArray memory self) internal constant returns (bytes memory bts) {
        if (self._len == 0) {
            return;
        }
        bts = new bytes(self._len);
        uint btsptr;
        assembly {
            btsptr := add(bts, 0x20)
        }
        unsafeCopy(btsptr, self._ptr, self._len);
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
    function copy(MemoryArray memory src) constant internal returns (MemoryArray memory dest) {
        dest = allocate(src._len);
        uint srcP = src._ptr;
        uint destP = dest._ptr;
        unsafeCopy(destP, srcP, src._len);
    }

    // Copy a memory array 'src' into a pre-allocated array 'dest'
    function copy(MemoryArray memory src, MemoryArray memory dest) constant internal {
        uint srcP = src._ptr;
        uint destP = dest._ptr;
        unsafeCopy(destP, srcP, src._len);
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

}