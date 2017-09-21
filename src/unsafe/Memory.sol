pragma solidity ^0.4.16;
pragma experimental "v0.5.0";
pragma experimental ABIEncoderV2;

library Memory {

    /* A Array contains a pointer to a memory address, and a length.
     * WARNING - don't manipulate these fields directly, as they make
     * up a section of memory that is guaranteed to be allocated. Additionally,
     * Array should not be created directly, but only gotten through
     * the functions in this library.
     */
    struct Array {
        uint _len;
        uint _ptr;
    }

    // Allocates 'size' bytes of memory and returns a Array object.
    function allocate(uint numBytes) internal pure returns (Array memory mArr) {
        mArr._len = numBytes;
        mArr._ptr = unsafeAllocate(numBytes);
    }

    // Copy a memory array. This allocates new memory and adds it
    function copy(Array memory self) internal pure returns (Array memory dest) {
        require(!isNull(self));
        dest = allocate(self._len);
        uint srcP = self._ptr;
        uint destP = dest._ptr;
        unsafeCopy(srcP, destP, self._len);
    }

    // Copy a memory array 'src' into a pre-allocated array 'dest'
    function copy(Array memory self, Array memory dest) internal pure {
        require(!isNull(self) && !isNull(dest) && self._len == dest._len);
        uint srcP = self._ptr;
        uint destP = dest._ptr;
        unsafeCopy(srcP, destP, self._len);
    }

    function equals(Array memory self, Array memory other) internal pure returns (bool equal) {
        if (self._len != other._len) {
            return false;
        }
        return equals(self._ptr, other._ptr, self._len);
    }

    function equalsRef(Array memory self, Array memory other) internal pure returns (bool equal) {
        equal = self._len == other._len && self._ptr == other._ptr;
    }

    function isNull(Array memory self) internal pure returns (bool) {
        return self._ptr == 0 && self._len == 0;
    }

    function equals(uint addr, uint addr2, uint len) internal pure returns (bool equal) {
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

    function equals(uint addr, uint len, bytes memory bts) internal pure returns (bool equal) {
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
    // UNSAFE because it does not produce an Array object that couples the
    // address with the number of allocated bytes. This has to be tracked manually.
    function unsafeAllocate(uint numBytes) internal pure returns (uint addr) {
        // Take the current value of the free memory pointer, and update.
        assembly {
            addr := mload(0x40)
            mstore(0x40, add(addr, numBytes))
        }
    }

    // Copies 'len' bytes of memory from address 'src' to address 'dest'
    // UNSAFE because there is no checking that the destination has been
    // properly allocated.
    function unsafeCopy(uint src, uint dest, uint len) internal pure {
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

    /******************** get memory address from types **********************/


    function memAddress(bytes memory bts) internal pure returns (uint addr) {
        assembly {
            addr := bts
        }
    }

    function memAddressData(bytes memory bts) internal pure returns (uint addr) {
        assembly {
            addr := add(bts, 0x20)
        }
    }

    function memAddress(string memory str) internal pure returns (uint addr) {
        assembly {
            addr := str
        }
    }

    function memAddressData(string memory str) internal pure returns (uint addr) {
        assembly {
            addr := add(str, 0x20)
        }
    }

    /******************** from types **********************/

    function fromBytes(bytes memory bts) internal pure returns (Array memory mArr) {
        uint addr;
        uint len;
        assembly {
            len := mload(bts)
            addr := add(bts, 0x20)
        }
        mArr._len = len;
        mArr._ptr = addr;
    }

    function fromString(string memory str) internal pure returns (Array memory mArr) {
        uint addr;
        uint len;
        assembly {
            len := mload(str)
            addr := add(str, 0x20)
        }
        mArr._len = len;
        mArr._ptr = addr;
    }

    function fromUint(uint n) internal pure returns (Array memory mArr) {
        mArr = allocate(32);
        uint ptr = mArr._ptr;
        assembly {
            mstore(ptr, n)
        }
    }

    function fromBytes32(bytes32 b32) internal pure returns (Array memory mArr) {
        mArr = allocate(32);
        uint ptr = mArr._ptr;
        assembly {
            mstore(ptr, b32)
        }
    }

    /******************** to types **********************/

    function toBytes(Array memory self) internal pure returns (bytes memory bts) {
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

    function toString(Array memory self) internal pure returns (string memory str) {
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

    function toUint(Array memory mArr) internal pure returns (uint n) {
        require(!isNull(mArr) && 0 < mArr._len && mArr._len <= 32);
        uint ptr = mArr._ptr;
        assembly {
            n := mload(ptr)
        }
        n &= ~(~uint(0) << mArr._len*8);
    }

    function toBytes32(Array memory mArr) internal pure returns (bytes32 b32) {
        require(!isNull(mArr) && mArr._len == 32);
        uint ptr = mArr._ptr;
        assembly {
            b32 := mload(ptr)
        }
    }

}