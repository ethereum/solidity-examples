pragma solidity ^0.4.16;
pragma experimental "v0.5.0";
pragma experimental "ABIEncoderV2";

/**
 * @title Bits
 * @author Andreas Olofsson (androlo@tutanota.de)
 * @dev Functions for operating on individual bits.
 */
library Bits {

    uint constant ONE = uint(1);

    uint constant ONES = uint(~0);

    // Set the bit 'self[index]'.
    // self[index] = 1
    function setBit(uint self, uint8 index) internal pure returns (uint) {
        return self | ONE << index;
    }

    // Clear the bit 'self[index]'.
    // self[index] = 0
    function clearBit(uint self, uint8 index) internal pure returns (uint) {
        return self & ~(ONE << index);
    }

    // Toggle the bit 'self[index]'.
    // self[index] = ~self[index]
    function toggleBit(uint self, uint8 index) internal pure returns (uint) {
        return self ^ ONE << index;
    }

    // Get the bit 'self[index]'.
    // x = self[index]
    function bit(uint self, uint8 index) internal pure returns (uint8) {
        return uint8(self >> index & 1);
    }

    // Check if the bit 'self[index]' is set.
    // self[index] == 1
    function bitSet(uint self, uint8 index) internal pure returns (bool) {
        return self >> index & 1 == 1;
    }

    // Check if the bits 'self[index]' and 'other[index]' are equal.
    // self[index] == other[equal]
    function bitEqual(uint self, uint other, uint8 index) internal pure returns (bool) {
        return (self ^ other) >> index & 1 == 0;
    }

    // Get the bitwise 'and' of the bit 'self[index]' and 'other[index]'.
    // x = self[index] & other[index]
    function bitAnd(uint self, uint other, uint8 index) internal pure returns (uint8) {
        return uint8((self & other) >> index & 1);
    }

    // Get the bitwise 'or' of the bit 'self[index]' and 'other[index]'.
    // x = self[index] | other[index]
    function bitOr(uint self, uint other, uint8 index) internal pure returns (uint8) {
        return uint8((self | other) >> index & 1);
    }

    // Get the bitwise 'xor' of the bit 'self[index]' and 'other[index]'.
    // x = self[index] ^ other[index]
    function bitXor(uint self, uint other, uint8 index) internal pure returns (uint8) {
        return uint8((self ^ other) >> index & 1);
    }

    // Copy the bits 'self[startIndex]' to 'self[startIndex + numBits]' into a new uint'.
    // The returned uint has self[startIndex] as the first bit
    // Example: bits(1101111011000111, 2, 6) = 100011
    function bits(uint self, uint8 startIndex, uint numBits) internal pure returns (uint) {
        require(startIndex + numBits <= 256 && numBits > 0);
        return self >> startIndex & ONES >> 256 - numBits;
    }

    /// Returns the highest bit set in the bitfield, where the 0th bit
    /// is the least significant.
    /// Throws if bitfield is zero.
    function highestBitSet(uint self) internal pure returns (uint8 highest) {
        require(self != 0);
        uint val = self;
        for (uint8 i = 128; i >= 1; i >>= 1) {
            if (val & (ONE << i) - 1 << i != 0) {
                highest += i;
                val >>= i;
            }
        }
    }

    /// Returns the first bit set in the bitfield, where the 0th bit
    /// is the least significant.
    /// Throws if bitfield is zero.
    function lowestBitSet(uint self) internal pure returns (uint8 lowest) {
        require(self != 0);
        uint val = self;
        for (uint8 i = 128; i >= 1; i >>= 1) {
            if (val & (ONE << i) - 1 == 0) {
                lowest += i;
                val >>= i;
            }
        }
    }

}