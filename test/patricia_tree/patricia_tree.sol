pragma solidity ^0.4.16;
pragma experimental "v0.5.0";
pragma experimental "ABIEncoderV2";

import {Data} from "../../src/patricia_tree/Data.sol";
import {PatriciaTree} from "../../src/patricia_tree/PatriciaTree.sol";
import {STLTest} from "../STLTest.sol";


/* solhint-disable no-empty-blocks */
contract PatriciaTreeTest is STLTest, PatriciaTree {}
/* solhint-enable no-empty-blocks */


contract TestPatriciaTreeInsert is PatriciaTreeTest {
    function testImpl() internal {

        bytes memory keyBts = "val";
        bytes memory valBts = "VAL";
        bytes32 keyHash = keccak256(keyBts); // 749eb9a32604a1e3d5563e475f22a54221a22999f274fb5acd84a00d16053a11
        bytes32 valHash = keccak256(valBts); // 6a96595ccfcb78ff3e886e67a3c94a0c6c8fe147c51512c4f9b5e8aa8d636f07

        insert("val", "VAL");

        assert(tree.rootEdge.node == valHash);
        assert(tree.rootEdge.label.data == keyHash);
        assert(tree.rootEdge.label.length == 256);
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

        var node = tree.nodes[tree.rootEdge.node];
        var c0 = node.children[0];
        var c1 = node.children[1];

        assert(tree.rootEdge.label.length == 1);
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

        assert(pt1.getRootHash() == pt2.getRootHash());
    }
}
