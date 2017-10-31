pragma solidity ^0.4.16;
pragma experimental "v0.5.0";
pragma experimental "ABIEncoderV2";

import {Bytes} from "../src/bytes/Bytes.sol";


contract BytesExamples {

    using Bytes for *;

    // Check if bytes are equal.
    function bytesEqualsExample() public pure {
        bytes memory bts0 = hex"01020304";
        bytes memory bts1 = hex"01020304";
        bytes memory bts2 = hex"05060708";

        assert(bts0.equals(bts0)); // Check if a byte array equal to itself.
        assert(bts0.equals(bts1)); // Should be equal because they have the same byte at each position.
        assert(!bts0.equals(bts2)); // Should not be equal.
    }

    // Check reference equality
    function bytesEqualsRefExample() public pure {
        bytes memory bts0 = hex"01020304";
        bytes memory bts1 = bts0;

        // Every 'bytes' will satisfy 'equalsRef' with itself.
        assert(bts0.equalsRef(bts0));
        // Different variables, but bts0 was assigned to bts1, so they point to the same area in memory.
        assert(bts0.equalsRef(bts1));
        // Changing a byte in bts0 will also affect bts1.
        bts0[2] = 0x55;
        assert(bts1[2] == 0x55);

        bytes memory bts2 = hex"01020304";
        bytes memory bts3 = hex"01020304";

        // These bytes has the same byte at each pos (so they would pass 'equals'), but they are referencing different areas in memory.
        assert(!bts2.equalsRef(bts3));

        // Changing a byte in bts2 will not affect bts3.
        bts2[2] = 0x55;
        assert(bts3[2] != 0x55);
    }

    // copying
    function bytesCopyExample() public pure {
        bytes memory bts0 = hex"01020304";

        var bts0Copy0 = bts0.copy();

        // The individual bytes are the same.
        assert(bts0.equals(bts0Copy0));
        // bts0Copy is indeed a (n independent) copy.
        assert(!bts0.equalsRef(bts0Copy0));

        bytes memory bts1 = hex"0304";

        // Copy with start index.
        var bts0Copy1 = bts0.copy(2);

        assert(bts0Copy1.equals(bts1));

        bytes memory bts2 = hex"0203";

        // Copy with start index and length.
        var bts0Copy2 = bts0.copy(1, 2);

        assert(bts0Copy2.equals(bts2));
    }

    // concatenate
    function bytesConcatExample() public pure {
        bytes memory bts0 = hex"01020304";
        bytes memory bts1 = hex"05060708";

        bytes memory bts01 = hex"0102030405060708";

        var cct = bts0.concat(bts1);

        // Should be equal to bts01
        assert(cct.equals(bts01));
    }

    // find the highest byte set in a bytes32
    function bytes32HighestByteSetExample() public pure {
        bytes32 test0 = 0x01;
        bytes32 test1 = 0xbb00aa00;
        bytes32 test2 = "abc";

        // with bytesN, the highest byte is the least significant one.
        assert(test0.highestByteSet() == 31);
        assert(test1.highestByteSet() == 30); // aa
        assert(test2.highestByteSet() == 2);

        // Make sure that in the case of test2, the highest byte is equal to "c".
        assert(test2[test2.highestByteSet()] == 0x63);
    }

    // find the lowest byte set in a bytes32
    function bytes32LowestByteSetExample() public pure {
        bytes32 test0 = 0x01;
        bytes32 test1 = 0xbb00aa00;
        bytes32 test2 = "abc";

        // with bytesN, the lowest byte is the most significant one.
        assert(test0.lowestByteSet() == 31);
        assert(test1.lowestByteSet() == 28); // bb
        assert(test2.lowestByteSet() == 0);
    }

    // find the highest byte set in a uint
    function uintHighestByteSetExample() public pure {
        uint test0 = 0x01;
        uint test1 = 0xbb00aa00;

        // with uint, the highest byte is the most significant one.
        assert(test0.highestByteSet() == 0);
        assert(test1.highestByteSet() == 3);
    }

    // find the lowest byte set in a uint
    function uintLowestByteSetExample() public pure {
        uint test0 = 0x01;
        uint test1 = 0xbb00aa00;

        // with uint, the lowest byte is the least significant one.
        assert(test0.lowestByteSet() == 0);
        assert(test1.lowestByteSet() == 1);
    }

}