pragma solidity ^0.4.16;
pragma experimental "v0.5.0";
pragma experimental "ABIEncoderV2";

import {Memory} from "../unsafe/Memory.sol";


library Bytes {

    uint internal constant BYTES_HEADER_SIZE = 32;

    // Checks if two `bytes memory` variables are equal. This is done using hashing,
    // which is much more gas efficient then comparing each byte individually.
    // Equality means that:
    //  - 'self.length == other.length'
    //  - For 'n' in '[0, self.length)', 'self[n] == other[n]'
    function equals(bytes memory self, bytes memory other) internal pure returns (bool equal) {
        if (self.length != other.length) {
            return false;
        }
        uint addr;
        uint addr2;
        assembly {
            addr := add(self, /*BYTES_HEADER_SIZE*/32)
            addr2 := add(other, /*BYTES_HEADER_SIZE*/32)
        }
        equal = Memory.equals(addr, addr2, self.length);
    }

    // Checks if two 'bytes memory' variables points to the same bytes array.
    // Technically this is done by de-referencing the two arrays in inline assembly,
    // and checking if the values are the same.
    function equalsRef(bytes memory self, bytes memory other) internal pure returns (bool equal) {
        assembly {
            equal := eq(self, other)
        }
    }

    // Copies a byte array.
    // Returns the copied bytes.
    // The function works by creating a new bytes array in memory, with the
    // same length as 'self', then copying all the bytes from 'self' into
    // the new array.
    function copy(bytes memory self) internal pure returns (bytes memory) {
        if (self.length == 0) {
            return;
        }
        var addr = Memory.dataPtr(self);
        return Memory.toBytes(addr, self.length);
    }

    // Copies a section of 'self' into a new array, starting at the provided 'startIndex'.
    // Returns the new copy.
    // Requires that 'startIndex <= self.length'
    // The length of the substring is: 'self.length - startIndex'
    function substr(bytes memory self, uint startIndex) internal pure returns (bytes memory) {
        require(startIndex <= self.length);
        var len = self.length - startIndex;
        var addr = Memory.dataPtr(self);
        return Memory.toBytes(addr + startIndex, len);
    }

    // Copies 'len' bytes from 'self' into a new array, starting at the provided 'startIndex'.
    // Returns the new copy.
    // Requires that:
    //  - 'startIndex + len <= self.length'
    // The length of the substring is: 'len'
    function substr(bytes memory self, uint startIndex, uint len) internal pure returns (bytes memory) {
        require(startIndex + len <= self.length);
        if (len == 0) {
            return;
        }
        var addr = Memory.dataPtr(self);
        return Memory.toBytes(addr + startIndex, len);
    }

    // Combines 'self' and 'other' into a single array.
    // Returns the concatenated arrays:
    //  [self[0], self[1], ... , self[self.length - 1], other[0], other[1], ... , other[other.length - 1]]
    // The length of the new array is 'self.length + other.length'
    function concat(bytes memory self, bytes memory other) internal pure returns (bytes memory) {
        bytes memory ret = new bytes(self.length + other.length);
        var (src, srcLen) = Memory.fromBytes(self);
        var (src2, src2Len) = Memory.fromBytes(other);
        var (dest,) = Memory.fromBytes(ret);
        var dest2 = dest + srcLen;
        Memory.copy(src, dest, srcLen);
        Memory.copy(src2, dest2, src2Len);
        return ret;
    }

    // Copies a section of a 'bytes32' starting at the provided 'startIndex'.
    // Returns the copied bytes (padded to the right) as a new 'bytes32'.
    // Requires that 'startIndex < 32'
    function substr(bytes32 self, uint8 startIndex) internal pure returns (bytes32) {
        require(startIndex < 32);
        return bytes32(uint(self) << startIndex*8);
    }

    // Copies 'len' bytes from 'self' into a new array, starting at the provided 'startIndex'.
    // Returns the copied bytes (padded to the right) as a new 'bytes32'.
    // Requires that:
    //  - 'startIndex < 32'
    //  - 'startIndex + len <= 32'
    function substr(bytes32 self, uint8 startIndex, uint8 len) internal pure returns (bytes32) {
        require(startIndex < 32 && startIndex + len <= 32);
        return bytes32(uint(self) << startIndex*8 & ~uint(0) << (32 - len)*8);
    }

    // Copies 'self' into a new 'bytes memory'.
    // Returns the newly created 'bytes memory'
    // The returned bytes will be of length '32'.
    function toBytes(bytes32 self) internal pure returns (bytes memory bts) {
        bts = new bytes(32);
        assembly {
            mstore(add(bts, /*BYTES_HEADER_SIZE*/32), self)
        }
    }

    // Copies 'len' bytes from 'self' into a new 'bytes memory', starting at index '0'.
    // Returns the newly created 'bytes memory'
    // The returned bytes will be of length 'len'.
    function toBytes(bytes32 self, uint8 len) internal pure returns (bytes memory bts) {
        require(len <= 32);
        bts = new bytes(len);
        // Even though the bytes will allocate a full word, we don't want
        // any potential garbage bytes in there.
        uint data = uint(self) & ~uint(0) << (32 - len)*8;
        assembly {
            mstore(add(bts, /*BYTES_HEADER_SIZE*/32), data)
        }
    }

    // Copies 'self' into a new 'bytes memory'.
    // Returns the newly created 'bytes memory'
    // The returned bytes will be of length '20'.
    function toBytes(address self) internal pure returns (bytes memory bts) {
        bts = toBytes(bytes32(uint(self) << 96), 20);
    }

    // Copies 'self' into a new 'bytes memory'.
    // Returns the newly created 'bytes memory'
    // The returned bytes will be of length '32'.
    function toBytes(uint self) internal pure returns (bytes memory bts) {
        bts = toBytes(bytes32(self), 32);
    }

    // Copies 'self' into a new 'bytes memory'.
    // Returns the newly created 'bytes memory'
    // Requires that:
    //  - '8 <= bitsize <= 256'
    //  - 'bitsize % 8 == 0'
    // The returned bytes will be of length 'bitsize / 8'.
    function toBytes(uint self, uint16 bitsize) internal pure returns (bytes memory bts) {
        require(8 <= bitsize && bitsize <= 256 && bitsize % 8 == 0);
        self <<= 256 - bitsize;
        bts = toBytes(bytes32(self), uint8(bitsize / 8));
    }

    // Copies 'self' into a new 'bytes memory'.
    // Returns the newly created 'bytes memory'
    // The returned bytes will be of length '1', and:
    //  - 'bts[0] == 0 (if self == false)'
    //  - 'bts[0] == 1 (if self == true)'
    function toBytes(bool self) internal pure returns (bytes memory bts) {
        bts = new bytes(1);
        bts[0] = self ? byte(1) : byte(0);
    }

    // Computes the index of the highest byte set in 'self'.
    // Returns the index.
    // Requires that 'self != 0'
    // Uses big endian ordering (the most significant byte has index '0').
    function highestByteSet(bytes32 self) internal pure returns (uint8 highest) {
        highest = 31 - lowestByteSet(uint(self));
    }

    // Computes the index of the lowest byte set in 'self'.
    // Returns the index.
    // Requires that 'self != 0'
    // Uses big endian ordering (the most significant byte has index '0').
    function lowestByteSet(bytes32 self) internal pure returns (uint8 lowest) {
        lowest = 31 - highestByteSet(uint(self));
    }

    // Computes the index of the highest byte set in 'self'.
    // Returns the index.
    // Requires that 'self != 0'
    // Uses little endian ordering (the least significant byte has index '0').
    function highestByteSet(uint self) internal pure returns (uint8 highest) {
        require(self != 0);
        uint ret;
        if (self & 0xffffffffffffffffffffffffffffffff00000000000000000000000000000000 != 0) {
            ret += 16;
            self >>= 128;
        }
        if (self & 0xffffffffffffffff0000000000000000 != 0) {
            ret += 8;
            self >>= 64;
        }
        if (self & 0xffffffff00000000 != 0) {
            ret += 4;
            self >>= 32;
        }
        if (self & 0xffff0000 != 0) {
            ret += 2;
            self >>= 16;
        }
        if (self & 0xff00 != 0) {
            ret += 1;
        }
        highest = uint8(ret);
    }

    // Computes the index of the lowest byte set in 'self'.
    // Returns the index.
    // Requires that 'self != 0'
    // Uses little endian ordering (the least significant byte has index '0').
    function lowestByteSet(uint self) internal pure returns (uint8 lowest) {
        require(self != 0);
        uint ret;
        if (self & 0xffffffffffffffffffffffffffffffff == 0) {
            ret += 16;
            self >>= 128;
        }
        if (self & 0xffffffffffffffff == 0) {
            ret += 8;
            self >>= 64;
        }
        if (self & 0xffffffff == 0) {
            ret += 4;
            self >>= 32;
        }
        if (self & 0xffff == 0) {
            ret += 2;
            self >>= 16;
        }
        if (self & 0xff == 0) {
            ret += 1;
        }
        lowest = uint8(ret);
    }

}
