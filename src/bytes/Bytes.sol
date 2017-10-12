pragma solidity ^0.4.16;
pragma experimental "v0.5.0";
pragma experimental "ABIEncoderV2";

import {Memory} from "../unsafe/Memory.sol";


library Bytes {

    function equals(bytes memory self, bytes memory other) internal pure returns (bool equal) {
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

    function equalsRef(bytes memory self, bytes memory other) internal pure returns (bool equal) {
        equal = Memory.ptr(self) == Memory.ptr(other);
    }

    function copy(bytes memory self) internal pure returns (bytes memory) {
        if (self.length == 0) {
            return;
        }
        var addr = Memory.dataPtr(self);
        return Memory.toBytes(addr, self.length);
    }

    function substr(bytes memory self, uint startIdx) internal pure returns (bytes memory) {
        require(startIdx < self.length);
        var len = self.length - startIdx;
        var addr = Memory.dataPtr(self);
        return Memory.toBytes(addr + startIdx, len);
    }

    function substr(bytes memory self, uint startIdx, uint len) internal pure returns (bytes memory) {
        require(startIdx < self.length && startIdx + len <= self.length);
        if (len == 0) {
            return;
        }
        var addr = Memory.dataPtr(self);
        return Memory.toBytes(addr + startIdx, len);
    }

    function concat(bytes memory self, bytes memory other) internal pure returns (bytes memory) {
        bytes memory ret = new bytes(self.length + other.length);
        var (src, srcLen) = Memory.fromBytes(self);
        var (src2, src2Len) = Memory.fromBytes(other);
        var (dest,) = Memory.fromBytes(ret);
        var dest2 = dest + src2Len;
        Memory.copy(src, dest, srcLen);
        Memory.copy(src2, dest2, src2Len);
        return ret;
    }

    function substr(bytes32 b32, uint8 startIndex) internal pure returns (bytes32) {
        require(startIndex < 32);
        return bytes32(uint(b32) << startIndex*8);
    }

    function substr(bytes32 b32, uint8 startIndex, uint8 len) internal pure returns (bytes32) {
        require(startIndex < 32 && startIndex + len <= 32);
        return bytes32(uint(b32) << startIndex*8 & ~uint(0) << (32 - len)*8);
    }

    function toBytes(bytes32 b32) internal pure returns (bytes memory bts) {
        bts = new bytes(32);
        assembly {
            mstore(add(bts, 0x20), b32)
        }
    }

    function toBytes(bytes32 b32, uint8 length) internal pure returns (bytes memory bts) {
        require(length <= 32);
        bts = new bytes(length);
        assembly {
            mstore(add(bts, 0x20), b32)
        }
    }

    function toBytes(address addr) internal pure returns (bytes memory bts) {
        bytes32 b32 = substr(bytes32(addr), 12);
        bts = toBytes(b32, 20);
    }

    function toBytes(uint n) internal pure returns (bytes memory bts) {
        bts = toBytes(bytes32(n), 32);
    }

    function toBytes(uint n, uint16 bitsize) internal pure returns (bytes memory bts) {
        require(8 <= bitsize && bitsize <= 256 && bitsize % 8 == 0);
        n <<= 256 - bitsize;
        bts = toBytes(bytes32(n), uint8(bitsize / 8));
    }

    function toBytes(bool b) internal pure returns (bytes memory bts) {
        bts = new bytes(1);
        bts[0] = b ? byte(1) : byte(0);
    }

    function highestByteSet(bytes32 self) internal pure returns (uint8 highest) {
        highest = 31 - lowestByteSet(uint(self));
    }

    function lowestByteSet(bytes32 self) internal pure returns (uint8 lowest) {
        lowest = 31 - highestByteSet(uint(self));
    }

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