pragma solidity ^0.4.15;


library Bits {

    uint constant ONE = uint(1);
    uint constant ONES = uint(~0);

    function setBit(uint self, uint8 index) internal constant returns (uint) {
        return self | (ONE << index);
    }

    function clearBit(uint self, uint8 index) internal constant returns (uint) {
        return self & ~(ONE << index);
    }

    function toggleBit(uint self, uint8 index) internal constant returns (uint) {
        return self ^ (ONE << index);
    }

    function bit(uint self, uint8 index) internal constant returns (uint8) {
        return uint8((self >> index) & 1);
    }

    function bitSet(uint self, uint8 index) internal constant returns (bool) {
        return (self >> index) & 1 == 1;
    }

    function bitEqual(uint self, uint other, uint8 index) internal constant returns (bool) {
        return (self >> index) & 1 == (other >> index) & 1;
    }

    function bitAnd(uint self, uint other, uint8 index) internal constant returns (uint8) {
        return uint8((self >> index & 1) & (other >> index & 1));
    }

    function bitOr(uint self, uint other, uint8 index) internal constant returns (uint8) {
        return uint8((self >> index & 1) | (other >> index & 1));
    }

    function bitXor(uint self, uint other, uint8 index) internal constant returns (uint8) {
        return uint8((self >> index & 1) ^ (other >> index & 1));
    }

    function bits(uint self, uint8 startIndex, uint8 numBits) internal constant returns (uint) {
        require(uint(startIndex) + uint(numBits) <= 256 && numBits > 0);
        return (self >> startIndex) & (ONES >> (256 - numBits));
    }

    /// Returns the last bit set in the bitfield, where the 0th bit
    /// is the least significant. Simple log2 by binary split (8 steps).
    /// Throws if bitfield is zero.
    /// More efficient the smaller the result is.
    function highestBitSet(uint self) internal constant returns (uint8 highest) {
        require(self != 0);
        uint val = self;
        for (uint8 i = 128; i >= 1; i >>= 1) {
            uint v = val >> i; // Take the upper half of the bits
            if (v != 0) {
                val = v; // If upper half is not 0, use that.
                highest += i;
            } else {
                val &= ((ONE << i) - 1); // Otherwise use lower
            }
        }
    }

    /// Returns the first bit set in the bitfield, where the 0th bit
    /// is the least significant. Process similar to 'highestBitSet'.
    /// Throws if bitfield is zero.
    /// More efficient the smaller the result is.
    function lowestBitSet(uint self) internal constant returns (uint8 lowest) {
        require(self != 0);
        uint val = self;
        for (uint8 i = 128; i >= 1; i >>= 1) {
            uint v = val & ((ONE << i) - 1); // Take the lower half of the bits
            if (v == 0) {
                val >>= i; // If lower half is 0 then continue with upper half.
                lowest += i;
            } else {
                val = v;
            }
        }
    }

}