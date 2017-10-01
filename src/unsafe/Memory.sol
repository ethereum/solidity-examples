pragma solidity ^0.4.16;
pragma experimental "v0.5.0";
pragma experimental "ABIEncoderV2";

/**
 * @title
 * @author Andreas Olofsson (androlo@tutanota.de)
 * @dev
 */
library Memory {

    function equals(uint addr, uint addr2, uint len) internal pure returns (bool equal) {
        assembly {
            equal := eq(keccak256(addr, len), keccak256(addr2, len))
        }
    }

    function equals(uint addr, uint len, bytes memory bts) internal pure returns (bool equal) {
        require(bts.length >= len);
        uint addr2;
        assembly {
            addr2 := add(bts, 0x20)
        }
        return equals(addr, addr2, len);
    }

    // Allocates 'numBytes' bytes of memory and returns a pointer to the starting address.
    // Additionally, all allocated bytes are equal to 0.
    function allocate(uint numBytes) internal pure returns (uint addr) {
        // Take the current value of the free memory pointer, and update.
        assembly {
            addr := mload(0x40)
            mstore(0x40, add(addr, numBytes))
        }
        uint words = (numBytes + 31) / 32;
        for (uint i = 0; i < words; i++) {
            assembly {
                mstore(add(addr, mul(i, 32)), 0)
            }
        }
    }

    // Copies 'len' bytes of memory from address 'src' to address 'dest'
    // UNSAFE because there is no checking that the destination has been
    // properly allocated.
    function copy(uint src, uint dest, uint len) internal pure {
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

    function ptr(bytes memory bts) internal pure returns (uint addr) {
        assembly {
            addr := bts
        }
    }

    function dataPtr(bytes memory bts) internal pure returns (uint addr) {
        assembly {
            addr := add(bts, 0x20)
        }
    }

    function ptr(string memory str) internal pure returns (uint addr) {
        assembly {
            addr := str
        }
    }

    function dataPtr(string memory str) internal pure returns (uint addr) {
        assembly {
            addr := add(str, 0x20)
        }
    }

    function fromBytes(bytes memory bts) internal pure returns (uint addr, uint len) {
        assembly {
            len := mload(bts)
            addr := add(bts, 0x20)
        }
    }

    function fromString(string memory str) internal pure returns (uint addr, uint len) {
        assembly {
            len := mload(str)
            addr := add(str, 0x20)
        }
    }

    /******************** to types **********************/

    function toBytes(uint addr, uint len) internal pure returns (bytes memory bts) {
        bts = new bytes(len);
        uint btsptr;
        assembly {
            btsptr := add(bts, 0x20)
        }
        copy(addr, btsptr, len);
    }

    function toString(uint addr, uint len) internal pure returns (string memory str) {
        str = new string(len);
        uint strptr;
        assembly {
            strptr := add(str, 0x20)
        }
        copy(addr, strptr, len);
    }

    function toUint(uint addr) internal pure returns (uint n) {
        assembly {
            n := mload(addr)
        }
    }

    function toBytes32(uint addr) internal pure returns (bytes32 bts) {
        assembly {
            bts := mload(addr)
        }
    }

    // Returns the byte at index 'index' of memory address 'addr'
    // Equivalent to 'toBytes32(addr)[index]'.
    function toByte(uint addr, uint8 index) internal pure returns (byte b) {
        require(index < 32);
        uint8 n;
        assembly {
            n := byte(index, mload(addr))
        }
        b = byte(n);
    }

}