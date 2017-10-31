pragma solidity ^0.4.16;
pragma experimental "v0.5.0";
pragma experimental "ABIEncoderV2";

//import {Bits} from "../../bits/Bits.sol";
import {Data} from "../../src/patricia_tree/Data.sol";
import {PatriciaTree} from "../../src/patricia_tree/PatriciaTree.sol";
import {STLTest} from "../STLTest.sol";

// TODO seems testing here is a bit over the top.
/*******************************************************/

contract PatriciaTreeDataTest is STLTest {

    using Data for Data.Node;
    using Data for Data.Edge;
    using Data for Data.Label;
    
    uint internal constant MAX_LENGTH = 256;
    uint internal constant UINT256_ZEROES = 0;
    uint internal constant UINT256_ONES = ~uint(0);

    bytes32 internal constant B32_ZEROES = bytes32(UINT256_ZEROES);
    bytes32 internal constant B32_ONES = bytes32(UINT256_ONES);
}


/* solhint-disable no-empty-blocks */
contract PatriciaTreeTest is STLTest, PatriciaTree {}
/* solhint-enable no-empty-blocks */

/*******************************************************/

contract TestPatriciaTreeDataChopFirstBitThrowsLengthIsZero is PatriciaTreeDataTest {
    function testImpl() internal {
        Data.Label memory lbl;
        lbl.chopFirstBit();
    }
}


contract TestPatriciaTreeDataChopFirstBitZeroes is PatriciaTreeDataTest {
    function testImpl() internal {
        Data.Label memory lbl = Data.Label(B32_ZEROES, 256);
        uint bit;
        for (uint i = 1; i <= 256; i++) {
            (bit, lbl) = lbl.chopFirstBit();
            require(bit == 0);
            require(lbl.data == B32_ZEROES);
            require(lbl.length == MAX_LENGTH - i);
        }
    }
}


contract TestPatriciaTreeDataChopFirstBitOnes is PatriciaTreeDataTest {
    function testImpl() internal {
        Data.Label memory lbl = Data.Label(B32_ONES, 256);
        uint bit;
        for (uint i = 1; i <= 256; i++) {
            (bit, lbl) = lbl.chopFirstBit();
            require(bit == 1);
            require(lbl.data == B32_ONES << i);
            require(lbl.length == MAX_LENGTH - i);
        }
    }
}


contract TestPatriciaTreeDataChopFirstBitDoesNotMutate is PatriciaTreeDataTest {
    function testImpl() internal {
        Data.Label memory lbl = Data.Label(B32_ONES, 256);
        lbl.chopFirstBit();
        require(lbl.data == B32_ONES);
        require(lbl.length == 256);
    }
}


contract TestPatriciaTreeDataRemovePrefixThrowsLessLengthZero is PatriciaTreeDataTest {
    function testImpl() internal {
        Data.Label memory lbl;
        lbl.removePrefix(1);
    }
}


contract TestPatriciaTreeDataRemovePrefixThrowsLessLengthNonZero is PatriciaTreeDataTest {
    function testImpl() internal {
        Data.Label memory lbl = Data.Label(B32_ZEROES, 5);
        lbl.removePrefix(6);
    }
}


contract TestPatriciaTreeDataRemoveZeroPrefixLengthZero is PatriciaTreeDataTest {
    function testImpl() internal {
        Data.Label memory lbl = Data.Label(B32_ONES, 0);
        lbl = lbl.removePrefix(0);
        require(lbl.data == B32_ONES);
        require(lbl.length == 0);
    }
}


contract TestPatriciaTreeDataRemoveZeroPrefixLength256 is PatriciaTreeDataTest {
    function testImpl() internal {
        Data.Label memory lbl = Data.Label(B32_ONES, 256);
        lbl = lbl.removePrefix(0);
        require(lbl.data == B32_ONES);
        require(lbl.length == 256);
    }
}


contract TestPatriciaTreeDataRemoveFullPrefixLength256 is PatriciaTreeDataTest {
    function testImpl() internal {
        Data.Label memory lbl = Data.Label(B32_ONES, 256);
        lbl = lbl.removePrefix(256);
        require(lbl.data == B32_ZEROES);
        require(lbl.length == 0);
    }
}


contract TestPatriciaTreeDataRemovePrefix is PatriciaTreeDataTest {
    function testImpl() internal {
        Data.Label memory lbl = Data.Label(hex"ef1230", 20);
        lbl = lbl.removePrefix(4);
        require(lbl.length == 16);
        require(lbl.data == hex"f123");
        lbl = lbl.removePrefix(15);
        require(lbl.length == 1);
        require(lbl.data == hex"80");
        lbl = lbl.removePrefix(1);
        require(lbl.length == 0);
        require(lbl.data == 0);
    }
}


contract TestPatriciaTreeDataRemovePrefixOnes is PatriciaTreeDataTest {
    function testImpl() internal {
        Data.Label memory lbl = Data.Label(B32_ONES, 256);
        for (uint i = 1; i <= 256; i++) {
            lbl = lbl.removePrefix(1);
            require(lbl.data == B32_ONES << i);
            require(lbl.length == MAX_LENGTH - i);
        }
    }
}


contract TestPatriciaTreeDataRemovePrefixDoesNotMutate is PatriciaTreeDataTest {
    function testImpl() internal {
        Data.Label memory lbl = Data.Label(hex"ef1230", 20);
        lbl.removePrefix(4);
        require(lbl.data == hex"ef1230");
        require(lbl.length == 20);
    }
}


contract TestPatriciaTreeDataCommonPrefixOfZeroLengthLabelsIsZero is PatriciaTreeDataTest {
    function testImpl() internal {
        Data.Label memory a;
        Data.Label memory b;
        require(a.commonPrefix(b) == 0);
    }
}


contract TestPatriciaTreeDataCommonPrefixOfNonZeroAndZeroLabelIsZero is PatriciaTreeDataTest {
    function testImpl() internal {
        Data.Label memory a = Data.Label(B32_ONES, 256);
        Data.Label memory b;
        require(a.commonPrefix(b) == 0);
    }
}


contract TestPatriciaTreeDataCommonPrefixOfLabelWithItselfIsLabelLength is PatriciaTreeDataTest {
    function testImpl() internal {
        Data.Label memory a = Data.Label(B32_ONES, 164);
        require(a.commonPrefix(a) == 164);
    }
}


contract TestPatriciaTreeDataSplitAtThrowsPosGreaterThanLength is PatriciaTreeDataTest {
    function testImpl() internal {
        Data.Label memory lbl = Data.Label(B32_ZEROES, 0);
        lbl.splitAt(1);
    }
}


contract TestPatriciaTreeDataSplitAtThrowsPosGreaterThan256 is PatriciaTreeDataTest {
    function testImpl() internal {
        Data.Label memory lbl = Data.Label(B32_ZEROES, 0);
        lbl.splitAt(257);
    }
}


contract TestPatriciaTreeDataSplitAtPosEqualToLengthDoesntFail is PatriciaTreeDataTest {
    function testImpl() internal {
        Data.Label memory lbl = Data.Label(B32_ZEROES, 2);
        lbl.splitAt(2);
    }
}


contract TestPatriciaTreeDataSplitAtPosEqualTo256DoesntFail is PatriciaTreeDataTest {
    function testImpl() internal {
        Data.Label memory lbl = Data.Label(B32_ZEROES, 256);
        lbl.splitAt(256);
    }
}


contract TestPatriciaTreeDataSplitAtDoesntMutate is PatriciaTreeDataTest {
    function testImpl() internal {
        Data.Label memory lbl = Data.Label(B32_ONES, 55);
        lbl.splitAt(43);
        require(lbl.data == B32_ONES);
        require(lbl.length == 55);
    }
}


contract TestPatriciaTreeDataSplitAtZero is PatriciaTreeDataTest {
    function testImpl() internal {
        Data.Label memory lbl = Data.Label(B32_ONES, 55);
        var (pre, suf) = lbl.splitAt(0);
        require(pre.data == B32_ZEROES);
        require(pre.length == 0);
        require(suf.data == B32_ONES);
        require(suf.length == 55);
    }
}


contract TestPatriciaTreeDataSplitAt is PatriciaTreeDataTest {
    function testImpl() internal {
        Data.Label memory a = Data.Label(hex"abcd", 16);

        var (x, y) = a.splitAt(0);
        require(x.length == 0);
        require(y.length == a.length);
        require(y.data == a.data);

        (x, y) = a.splitAt(4);
        require(x.length == 4);
        require(x.data == hex"a0");
        require(y.length == 12);
        require(y.data == hex"bcd0");

        (x, y) = a.splitAt(16);
        require(y.length == 0);
        require(x.length == a.length);
        require(x.data == a.data);
    }
}


contract TestPatriciaTreeDataSplitCommonPrefixDoesNotMutate is PatriciaTreeDataTest {
    function testImpl() internal {
        Data.Label memory a = Data.Label(hex"abcd", 16);
        Data.Label memory b = Data.Label(hex"a0f570", 20);
        a.splitCommonPrefix(b);

        require(a.data == hex"abcd");
        require(a.length == 16);
        require(b.data == hex"a0f570");
        require(b.length == 20);
    }
}


contract TestPatriciaTreeDataSplitCommonPrefixWithItself is PatriciaTreeDataTest {
    function testImpl() internal {
        Data.Label memory a = Data.Label(hex"abcd", 16);
        var (pre, suf) = a.splitCommonPrefix(a);
        require(pre.data == a.data);
        require(pre.length == a.length);

        require(suf.data == B32_ZEROES);
        require(suf.length == 0);
    }
}


contract TestPatriciaTreeDataSplitCommonPrefixWithZeroLabel is PatriciaTreeDataTest {
    function testImpl() internal {
        Data.Label memory a = Data.Label(B32_ZEROES, 0);
        Data.Label memory b = Data.Label(hex"a0f570", 20);
        var (pre, suf) = a.splitCommonPrefix(b);

        require(pre.data == B32_ZEROES);
        require(pre.length == 0);
        require(suf.data == a.data);
        require(suf.length == a.length);
    }
}


contract TestPatriciaTreeDataSplitCommonPrefixWithZeroCheck is PatriciaTreeDataTest {
    function testImpl() internal {
        Data.Label memory a = Data.Label(B32_ZEROES, 0);
        Data.Label memory b = Data.Label(hex"a0f570", 20);
        var (pre, suf) = b.splitCommonPrefix(a);

        require(pre.data == B32_ZEROES);
        require(pre.length == 0);
        require(suf.data == b.data);
        require(suf.length == b.length);
    }
}


contract TestPatriciaTreeDataSplitCommonPrefix is PatriciaTreeDataTest {
    function testImpl() internal {
        Data.Label memory a = Data.Label(hex"abcd", 16);
        Data.Label memory b = Data.Label(hex"a0f570", 20);

        var (prefix, suffix) = b.splitCommonPrefix(a);
        require(prefix.length == 4);
        require(prefix.data == hex"a0");
        require(suffix.length == 16);
        require(suffix.data == hex"0f57");
    }
}

/************************** Patricia Tree *****************************/

contract TestPatriciaTreeInsert is PatriciaTreeTest {
    function testImpl() internal {

        bytes memory keyBts = "val";
        bytes memory valBts = "VAL";
        bytes32 keyHash = keccak256(keyBts); // 749eb9a32604a1e3d5563e475f22a54221a22999f274fb5acd84a00d16053a11
        bytes32 valHash = keccak256(valBts); // 6a96595ccfcb78ff3e886e67a3c94a0c6c8fe147c51512c4f9b5e8aa8d636f07

        insert("val", "VAL");

        assert(rootEdge.node == valHash);
        assert(rootEdge.label.data == keyHash);
        assert(rootEdge.label.length == 256);
    }
}


contract TestPatriciaTreeInsertTwo is PatriciaTreeTest {
    function testImpl() internal {
        bytes memory valBts = "VAL";
        bytes memory val2Bts = "VAL2";

        bytes32 valHash = keccak256(valBts); // 6a96595ccfcb78ff3e886e67a3c94a0c6c8fe147c51512c4f9b5e8aa8d636f07
        bytes32 val2Hash = keccak256(val2Bts); // 780f7d9be6b7b221c27f7d5e84ff9ff220b60283dd7d012fbd9195bb6bb472aa

        insert("val", "VAL");
        insert("val2", "VAL2");

        var node = nodes[rootEdge.node];
        var c0 = node.children[0];
        var c1 = node.children[1];

        assert(rootEdge.label.length == 1);
        assert(c0.node == val2Hash);
        assert(c0.label.length == 254);
        assert(c1.node == valHash);
        assert(c1.label.length == 254);
    }
}


contract TestPatriciaTreeInsertOrderDoesNotMatter is STLTest {
    function testImpl() internal {
        var pt1 = new PatriciaTree();
        var pt2 = new PatriciaTree();
        pt1.insert("testkey", "testval");
        pt1.insert("testkey2", "testval2");
        pt1.insert("testkey3", "testval3");
        pt1.insert("testkey4", "testval4");
        pt1.insert("testkey5", "testval5");

        pt2.insert("testkey2", "testval2");
        pt2.insert("testkey", "testval");
        pt2.insert("testkey5", "testval5");
        pt2.insert("testkey3", "testval3");
        pt2.insert("testkey4", "testval4");

        assert(pt1.root() == pt2.root());
    }
}
