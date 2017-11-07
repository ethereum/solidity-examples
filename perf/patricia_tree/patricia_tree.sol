pragma solidity ^0.4.16;
pragma experimental "v0.5.0";
pragma experimental "ABIEncoderV2";

import {Data} from "../../src/patricia_tree/Data.sol";
import {PatriciaTree} from "../../src/patricia_tree/PatriciaTree.sol";
import {STLPerf} from "../STLPerf.sol";


contract PatriciaTreeDataPerf is STLPerf {
    using Data for Data.Tree;
    using Data for Data.Node;
    using Data for Data.Edge;
    using Data for Data.Label;

    uint internal constant MAX_LENGTH = 256;
    uint internal constant UINT256_ZEROES = 0;
    uint internal constant UINT256_ONES = ~uint(0);

    bytes32 internal constant B32_ZEROES = bytes32(UINT256_ZEROES);
    bytes32 internal constant B32_ONES = bytes32(UINT256_ONES);
}


contract PerfPatriciaTreeInsertIntoEmpty is PatriciaTreeDataPerf {
    function perf() public payable returns (uint) {
        var pt = new PatriciaTree();
        uint gasPre = msg.gas;
        pt.insert("val", "VAL");
        uint gasPost = msg.gas;
        return gasPre - gasPost;
    }
}


contract PerfPatriciaTreeInsertAfterRoot is PatriciaTreeDataPerf {
    function perf() public payable returns (uint) {
        var pt = new PatriciaTree();
        pt.insert("val", "VAL");
        uint gasPre = msg.gas;
        pt.insert("val2", "VAL2");
        uint gasPost = msg.gas;
        return gasPre - gasPost;
    }
}


contract PerfPatriciaTreeInsertReplaceRoot is PatriciaTreeDataPerf {
    function perf() public payable returns (uint) {
        var pt = new PatriciaTree();
        pt.insert("val", "VAL");
        uint gasPre = msg.gas;
        pt.insert("val", "VAL2");
        uint gasPost = msg.gas;
        return gasPre - gasPost;
    }
}


contract PerfPatriciaTreeInsertReplaceAfterRoot is PatriciaTreeDataPerf {
    function perf() public payable returns (uint) {
        var pt = new PatriciaTree();
        pt.insert("val", "VAL");
        pt.insert("val2", "VAL2");
        uint gasPre = msg.gas;
        pt.insert("val2", "VAL3");
        uint gasPost = msg.gas;
        return gasPre - gasPost;
    }
}


contract PerfPatriciaTreeGetProofRoot is PatriciaTreeDataPerf {
    function perf() public payable returns (uint) {
        var pt = new PatriciaTree();
        pt.insert("val", "VAL");
        uint gasPre = msg.gas;
        pt.getProof("val");
        uint gasPost = msg.gas;
        return gasPre - gasPost;
    }
}


contract PerfPatriciaTreeGetProofSecondAfterRoot is PatriciaTreeDataPerf {
    function perf() public payable returns (uint) {
        var pt = new PatriciaTree();
        pt.insert("val", "VAL");
        pt.insert("val2", "VAL2");
        uint gasPre = msg.gas;
        pt.getProof("val2");
        uint gasPost = msg.gas;
        return gasPre - gasPost;
    }
}


contract PerfPatriciaTreeValidateProofRootOnlyNode is PatriciaTreeDataPerf, PatriciaTree {
    function perf() public payable returns (uint) {
        insert("val", "VAL");
        var (mask, siblings) = getProof("val");
        uint gasPre = msg.gas;
        verifyProof(tree.root, "val", "VAL", mask, siblings);
        uint gasPost = msg.gas;
        return gasPre - gasPost;
    }
}


contract PerfPatriciaTreeEdgeHash is PatriciaTreeDataPerf, PatriciaTree {
    function perf() public payable returns (uint) {
        var e = Data.Edge(0, Data.Label(0, 1));
        uint gasPre = msg.gas;
        e.edgeHash();
        uint gasPost = msg.gas;
        return gasPre - gasPost;
    }
}