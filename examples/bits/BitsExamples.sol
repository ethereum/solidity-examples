pragma solidity ^0.4.16;
pragma experimental "v0.5.0";
pragma experimental "ABIEncoderV2";

import {Bits} from "../src/bits/Bits.sol";


contract BitsExamples {

    using Bits for uint;

    // Set bits
    function setBitExample() public pure {
        uint n = 0;
        n = n.setBit(0); // Set the 0th bit.
        assert(n == 1);  // 1
        n = n.setBit(1); // Set the 1st bit.
        assert(n == 3);  // 11
        n = n.setBit(2); // Set the 2nd bit.
        assert(n == 7);  // 111
        n = n.setBit(3); // Set the 3rd bit.
        assert(n == 15); // 1111

        // x.bit(y) == 1 => x.setBit(y) == x
        n = 1;
        assert(n.setBit(0) == n);
    }

    // Clear bits
    function clearBitExample() public pure {
        uint n = 15;       // 1111
        n = n.clearBit(0); // Clear the 0th bit.
        assert(n == 14);   // 1110
        n = n.clearBit(1); // Clear the 1st bit.
        assert(n == 12);   // 1100
        n = n.clearBit(2); // Clear the 2nd bit.
        assert(n == 8);    // 1000
        n = n.clearBit(3); // Clear the 3rd bit.
        assert(n == 0);    // 0

        // x.bit(y) == 0 => x.clearBit(y) == x
        n = 0;
        assert(n.clearBit(0) == n);
    }

    // Toggle bits
    function toggleBitExample() public pure {
        uint n = 9;         // 1001
        n = n.toggleBit(0); // Toggle the 0th bit.
        assert(n == 8);     // 1000
        n = n.toggleBit(1); // Toggle the 1st bit.
        assert(n == 10);    // 1010
        n = n.toggleBit(2); // Toggle the 2nd bit.
        assert(n == 14);    // 1110
        n = n.toggleBit(3); // Toggle the 3rd bit.
        assert(n == 6);     // 0110

        // x.toggleBit(y).toggleBit(y) == x (invertible)
        n = 55;
        assert(n.toggleBit(5).toggleBit(5) == n);
    }

    // Get an individual bit
    function bitExample() public pure {
        uint n = 9; // 1001
        assert(n.bit(0) == 1);
        assert(n.bit(1) == 0);
        assert(n.bit(2) == 0);
        assert(n.bit(3) == 1);
    }

    // Is a bit set
    function bitSetExample() public pure {
        uint n = 9; // 1001
        assert(n.bitSet(0) == true);
        assert(n.bitSet(1) == false);
        assert(n.bitSet(2) == false);
        assert(n.bitSet(3) == true);
    }

    // Are bits equal
    function bitEqualExample() public pure {
        uint n = 9; // 1001
        uint m = 3; // 0011
        assert(n.bitEqual(m, 0) == true);
        assert(n.bitEqual(m, 1) == false);
        assert(n.bitEqual(m, 2) == true);
        assert(n.bitEqual(m, 3) == false);
    }

    // Bit 'not'
    function bitNotExample() public pure {
        uint n = 9; // 1001
        assert(n.bitNot(0) == 0);
        assert(n.bitNot(1) == 1);
        assert(n.bitNot(2) == 1);
        assert(n.bitNot(3) == 0);

        // x.bit(y) = 1 - x.bitNot(y);
        assert(n.bitNot(0) == 1 - n.bit(0));
        assert(n.bitNot(1) == 1 - n.bit(1));
        assert(n.bitNot(2) == 1 - n.bit(2));
        assert(n.bitNot(3) == 1 - n.bit(3));
    }

    // Bits 'and'
    function bitAndExample() public pure {
        uint n = 9; // 1001
        uint m = 3; // 0011
        assert(n.bitAnd(m, 0) == 1);
        assert(n.bitAnd(m, 1) == 0);
        assert(n.bitAnd(m, 2) == 0);
        assert(n.bitAnd(m, 3) == 0);
    }

    // Bits 'or'
    function bitOrExample() public pure {
        uint n = 9; // 1001
        uint m = 3; // 0011
        assert(n.bitOr(m, 0) == 1);
        assert(n.bitOr(m, 1) == 1);
        assert(n.bitOr(m, 2) == 0);
        assert(n.bitOr(m, 3) == 1);
    }

    // Bits 'xor'
    function bitXorExample() public pure {
        uint n = 9; // 1001
        uint m = 3; // 0011
        assert(n.bitXor(m, 0) == 0);
        assert(n.bitXor(m, 1) == 1);
        assert(n.bitXor(m, 2) == 0);
        assert(n.bitXor(m, 3) == 1);
    }

    // Get bits
    function bitsExample() public pure {
        uint n = 13;                // 0 ... 01101
        assert(n.bits(0, 4) == 13); // 1101
        assert(n.bits(1, 4) == 6);  // 0110
        assert(n.bits(2, 4) == 3);  // 0011
        assert(n.bits(3, 4) == 1);  // 0001

        assert(n.bits(0, 4) == 13); // 1101
        assert(n.bits(0, 3) == 5);  // 101
        assert(n.bits(0, 2) == 1);  // 01
        assert(n.bits(0, 1) == 1);  // 1
    }

    function bitsExampleThatFails() public pure {
        uint n = 13;
        n.bits(2, 0); // There is no zero-bit uint!
    }

    // Highest bit set
    function highestBitSetExample() public pure {
        uint n = 13;                    // 0 ... 01101
        assert(n.highestBitSet() == 3); //        ^

    }

    // Highest bit set
    function lowestBitSetExample() public pure {
        uint n = 12;                    // 0 ... 01100
        assert(n.lowestBitSet() == 2);  //         ^

    }

}