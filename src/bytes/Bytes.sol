pragma solidity ^0.4.15;

import {Memory} from "../unsafe/Memory.sol";

library Bytes {

    // Check if two 'bytes memory' are equal. Equality is defined as such:
    // firstBytes.length == secondBytes.length (= length)
    // for 0 <= i < length, firstBytes[i] == secondBytes[i]
    function equals(bytes memory self, bytes memory other) internal constant returns (bool equal) {
        if (self.length != other.length) {
            return false;
        }
        uint addr;
        uint addr2;
        assembly {
            addr := add(self, 0x20)
            addr2 := add(other, 0x20)
        }
        equal = Memory.equals(addr, addr2, self.length);
    }

    // Check if two bytes references are the same, i.e. has the same memory address.
    // If 'equals(self, other) == true', but 'equalsRef(self, other) == false', then
    // 'self' and 'other' must be independent copies of each other.
    function equalsRef(bytes memory self, bytes memory other) internal constant returns (bool equal) {
        equal = Memory.memAddress(self) == Memory.memAddress(other);
    }

    function copy(bytes memory self) internal constant returns (bytes memory cpy) {
        if (self.length == 0) {
            return;
        }
        cpy = new bytes(self.length);
        uint src;
        uint dest;
        assembly {
            src := add(self, 0x20)
            dest := add(cpy, 0x20)
        }
        Memory.unsafeCopy(src, dest, self.length);
    }

    function concat(bytes memory self, bytes memory other) internal constant returns (bytes memory) {
        bytes memory ret = new bytes(self.length + other.length);
        uint src = Memory.memAddressData(self);
        uint src2 = Memory.memAddressData(other);
        uint dest = Memory.memAddressData(ret);
        uint dest2 = dest + other.length;
        Memory.unsafeCopy(src, dest, self.length);
        Memory.unsafeCopy(src2, dest2, other.length);
        return ret;
    }

    /*
     * @dev Returns the length of a null-terminated bytes32 string.
     * @param self The value to find the length of.
     * @return The length of the string, from 0 to 32.
     *
     */
    function lowestByteSet(bytes32 self) internal constant returns (uint) {
        require(self != 0);
        uint ret;
        if (self & 0xffffffffffffffffffffffffffffffff == 0) {
            ret += 16;
            self = bytes32(uint(self) >> 128);
        }
        if (self & 0xffffffffffffffff == 0) {
            ret += 8;
            self = bytes32(uint(self) >> 64);
        }
        if (self & 0xffffffff == 0) {
            ret += 4;
            self = bytes32(uint(self) >> 32);
        }
        if (self & 0xffff == 0) {
            ret += 2;
            self = bytes32(uint(self) >> 16);
        }
        if (self & 0xff == 0) {
            ret += 1;
        }
        return ret;
    }

    function highestByteSet(bytes32 self) internal constant returns (uint) {
        require(self != 0);
        uint ret;
        if (self == 0)
            return 0;
        if (self & 0xffffffffffffffffffffffffffffffff00000000000000000000000000000000 != 0) {
            ret += 16;
            self = bytes32(uint(self) >> 128);
        }
        if (self & 0xffffffffffffffff0000000000000000 != 0) {
            ret += 8;
            self = bytes32(uint(self) >> 64);
        }
        if (self & 0xffffffff00000000 != 0) {
            ret += 4;
            self = bytes32(uint(self) >> 32);
        }
        if (self & 0xffff0000 != 0) {
            ret += 2;
            self = bytes32(uint(self) >> 16);
        }
        if (self & 0xff00 != 0) {
            ret += 1;
        }
        return ret;
    }

    // Shaves of leading 0 bytes and writes the remaining string to a 'memory bytes'
    function toBytes(bytes32 b32) internal constant returns (bytes memory bts) {
        if (b32 == 0) {
            return;
        }
        uint lbs = lowestByteSet(b32);
        uint bu = uint(b32);
        bts = new bytes(32 - lbs);
        assembly {
            mstore(add(bts, 0x20), bu)
        }
        return bts;
    }

}