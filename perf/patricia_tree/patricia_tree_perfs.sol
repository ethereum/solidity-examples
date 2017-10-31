pragma solidity ^0.4.16;
pragma experimental "v0.5.0";
pragma experimental "ABIEncoderV2";

import {Data} from "../../src/patricia_tree/Data.sol";
import {PatriciaTree} from "../../src/patricia_tree/PatriciaTree.sol";
import {STLPerf} from "../STLPerf.sol";


contract PatriciaUtilsPerf is STLPerf {
    using Data for Data.Node;
    using Data for Data.Edge;
    using Data for Data.Label;

    uint internal constant MAX_LENGTH = 256;
    uint internal constant UINT256_ZEROES = 0;
    uint internal constant UINT256_ONES = ~uint(0);

    bytes32 internal constant B32_ZEROES = bytes32(UINT256_ZEROES);
    bytes32 internal constant B32_ONES = bytes32(UINT256_ONES);
}


contract PerfPatriciaTreeDataChopFirstBit is PatriciaUtilsPerf {
    function perf() public payable returns (uint) {
        var lbl = Data.Label(0, 1);
        uint gasPre = msg.gas;
        lbl.chopFirstBit();
        uint gasPost = msg.gas;
        return gasPre - gasPost;
    }
}


contract PerfPatriciaTreeDataRemovePrefix is PatriciaUtilsPerf {
    function perf() public payable returns (uint) {
        var lbl = Data.Label(0, 5);
        uint gasPre = msg.gas;
        lbl.removePrefix(5);
        uint gasPost = msg.gas;
        return gasPre - gasPost;
    }
}


contract PerfPatriciaTreeDataCommonPrefixLengthZero is PatriciaUtilsPerf {
    function perf() public payable returns (uint) {
        var lbl = Data.Label(B32_ZEROES, 0);
        uint gasPre = msg.gas;
        lbl.commonPrefix(lbl);
        uint gasPost = msg.gas;
        return gasPre - gasPost;
    }
}


contract PerfPatriciaTreeDataCommonPrefixNoMatch is PatriciaUtilsPerf {
    function perf() public payable returns (uint) {
        var lbl = Data.Label(B32_ZEROES, 256);
        var lbl2 = Data.Label(B32_ONES, 256);
        uint gasPre = msg.gas;
        lbl.commonPrefix(lbl2);
        uint gasPost = msg.gas;
        return gasPre - gasPost;
    }
}


contract PerfPatriciaTreeDataCommonPrefixFullMatch is PatriciaUtilsPerf {
    function perf() public payable returns (uint) {
        var lbl = Data.Label(B32_ZEROES, 256);
        uint gasPre = msg.gas;
        lbl.commonPrefix(lbl);
        uint gasPost = msg.gas;
        return gasPre - gasPost;
    }
}


contract PerfPatriciaTreeDataSplitAtPositionZero is PatriciaUtilsPerf {
    function perf() public payable returns (uint) {
        var lbl = Data.Label(B32_ZEROES, 256);
        uint gasPre = msg.gas;
        lbl.splitAt(0);
        uint gasPost = msg.gas;
        return gasPre - gasPost;
    }
}


contract PerfPatriciaTreeDataSplitAt is PatriciaUtilsPerf {
    function perf() public payable returns (uint) {
        var lbl = Data.Label(B32_ZEROES, 256);
        uint gasPre = msg.gas;
        lbl.splitAt(55);
        uint gasPost = msg.gas;
        return gasPre - gasPost;
    }
}


contract PerfPatriciaTreeDataSplitCommonPrefix is PatriciaUtilsPerf {
    function perf() public payable returns (uint) {
        var lbl = Data.Label(B32_ZEROES, 256);
        var lbl2 = Data.Label(0x1111, 256);
        uint gasPre = msg.gas;
        lbl.splitCommonPrefix(lbl2);
        uint gasPost = msg.gas;
        return gasPre - gasPost;
    }
}


contract PerfPatriciaTreeInsertIntoEmpty is PatriciaUtilsPerf {
    function perf() public payable returns (uint) {
        var pt = new PatriciaTree();
        uint gasPre = msg.gas;
        pt.insert("val", "VAL");
        uint gasPost = msg.gas;
        return gasPre - gasPost;
    }
}


contract PerfPatriciaTreeInsertAfterRoot is PatriciaUtilsPerf {
    function perf() public payable returns (uint) {
        var pt = new PatriciaTree();
        pt.insert("val", "VAL");
        uint gasPre = msg.gas;
        pt.insert("val2", "VAL2");
        uint gasPost = msg.gas;
        return gasPre - gasPost;
    }
}


contract PerfPatriciaTreeInsertReplaceRoot is PatriciaUtilsPerf {
    function perf() public payable returns (uint) {
        var pt = new PatriciaTree();
        pt.insert("val", "VAL");
        uint gasPre = msg.gas;
        pt.insert("val", "VAL2");
        uint gasPost = msg.gas;
        return gasPre - gasPost;
    }
}


contract PerfPatriciaTreeInsertReplaceAfterRoot is PatriciaUtilsPerf {
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


contract PerfPatriciaTreeGetProofRoot is PatriciaUtilsPerf {
    function perf() public payable returns (uint) {
        var pt = new PatriciaTree();
        pt.insert("val", "VAL");
        uint gasPre = msg.gas;
        pt.getProof("val");
        uint gasPost = msg.gas;
        return gasPre - gasPost;
    }
}


contract PerfPatriciaTreeGetProofSecondAfterRoot is PatriciaUtilsPerf {
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


contract PerfPatriciaTreeValidateProofRootOnlyNode is PatriciaUtilsPerf, PatriciaTree {
    function perf() public payable returns (uint) {
        insert("val", "VAL");
        var (mask, siblings) = getProof("val");
        uint gasPre = msg.gas;
        verifyProof(root, "val", "VAL", mask, siblings);
        uint gasPost = msg.gas;
        return gasPre - gasPost;
    }
}


contract PerfPatriciaTreeEdgeHash is PatriciaUtilsPerf, PatriciaTree {
    function perf() public payable returns (uint) {
        var e = Data.Edge(0, Data.Label(0, 1));
        uint gasPre = msg.gas;
        edgeHash(e);
        uint gasPost = msg.gas;
        return gasPre - gasPost;
    }
}


// Make these part of extended suite later
/*
contract PerfPatriciaTreeGetProof1To10AverageCost is PatriciaUtilsPerf, PatriciaTree {
    function perf() public payable returns (uint) {
        var pt = new PatriciaTree();
        bytes memory bts = new bytes(1);
        for (uint i = 0; i < 10; i++) {
            bts[0] = byte(i);
            insert(bts, bts);
        }
        uint aggregateGas = 0;
        for (i = 0; i < 10; i++) {
            bts[0] = byte(i);
            uint gasPre = msg.gas;
            getProof(bts);
            aggregateGas += gasPre - msg.gas;
        }
        return aggregateGas / uint(10);
    }
}


contract PerfPatriciaTreeGetProof91To100AverageCost is PatriciaUtilsPerf, PatriciaTree {
    function perf() public payable returns (uint) {
        var pt = new PatriciaTree();
        bytes memory bts = new bytes(1);
        for (uint i = 0; i < 100; i++) {
            bts[0] = byte(i);
            insert(bts, bts);
        }
        uint aggregateGas = 0;
        for (i = 90; i < 100; i++) {
            bts[0] = byte(i);
            uint gasPre = msg.gas;
            getProof(bts);
            aggregateGas += gasPre - msg.gas;
        }
        return aggregateGas / uint(10);
    }
}


contract PerfPatriciaTreeGetProof191To200AverageCost is PatriciaUtilsPerf, PatriciaTree {
    function perf() public payable returns (uint) {
        var pt = new PatriciaTree();
        bytes memory bts = new bytes(1);
        for (uint i = 0; i < 200; i++) {
            bts[0] = byte(i);
            insert(bts, bts);
        }
        uint aggregateGas = 0;
        for (i = 190; i < 200; i++) {
            bts[0] = byte(i);
            uint gasPre = msg.gas;
            getProof(bts);
            aggregateGas += gasPre - msg.gas;
        }
        return aggregateGas / uint(10);
    }
}

contract PerfPatriciaTreeValidateProof1To10AverageCost is PatriciaUtilsPerf, PatriciaTree {
    function perf() public payable returns (uint) {
        bytes memory bts = new bytes(1);
        for (uint i = 0; i < 10; i++) {
            bts[0] = byte(i);
            insert(bts, bts);
        }
        uint aggregateGas = 0;
        for (i = 0; i < 10; i++) {
            bts[0] = byte(i);
            var (mask, siblings) = getProof(bts);
            uint gasPre = msg.gas;
            verifyProof(root, bts, bts, mask, siblings);
            aggregateGas += gasPre - msg.gas;
        }
        return aggregateGas / uint(10);
    }
}


contract PerfPatriciaTreeValidateProof91To100AverageCost is PatriciaUtilsPerf, PatriciaTree {
    function perf() public payable returns (uint) {
        bytes memory bts = new bytes(1);
        for (uint i = 0; i < 100; i++) {
            bts[0] = byte(i);
            insert(bts, bts);
        }
        uint aggregateGas = 0;
        for (i = 90; i < 100; i++) {
            bts[0] = byte(i);
            var (mask, siblings) = getProof(bts);
            uint gasPre = msg.gas;
            verifyProof(root, bts, bts, mask, siblings);
            aggregateGas += gasPre - msg.gas;
        }
        return aggregateGas / uint(10);
    }
}


contract PerfPatriciaTreeValidateProof191To200AverageCost is PatriciaUtilsPerf, PatriciaTree {
    function perf() public payable returns (uint) {
        bytes memory bts = new bytes(1);
        for (uint i = 0; i < 200; i++) {
            bts[0] = byte(i);
            insert(bts, bts);
        }
        uint aggregateGas = 0;
        for (i = 190; i < 200; i++) {
            bts[0] = byte(i);
            var (mask, siblings) = getProof(bts);
            uint gasPre = msg.gas;
            verifyProof(root, bts, bts, mask, siblings);
            aggregateGas += gasPre - msg.gas;
        }
        return aggregateGas / uint(10);
    }
}


contract PerfPatriciaTreeInsert1To10AverageCost is PatriciaUtilsPerf, PatriciaTree {
    function perf() public payable returns (uint) {
        bytes memory bts = new bytes(1);
        uint aggregateGas = 0;
        for (uint i = 0; i < 10; i++) {
            bts[0] = byte(i);
            uint gasPre = msg.gas;
            insert(bts, bts);
            aggregateGas += gasPre - msg.gas;
        }
        return aggregateGas / uint(10);
    }
}


contract PerfPatriciaTreeInsert91To100AverageCost is PatriciaUtilsPerf, PatriciaTree {
    function perf() public payable returns (uint) {
        bytes memory bts = new bytes(1);
        for (uint i = 0; i < 90; i++) {
            bts[0] = byte(i);
            insert(bts, bts);
        }
        uint aggregateGas = 0;
        for (i = 90; i < 100; i++) {
            bts[0] = byte(i);
            uint gasPre = msg.gas;
            insert(bts, bts);
            aggregateGas += gasPre - msg.gas;
        }
        return aggregateGas / uint(10);
    }
}


contract PerfPatriciaTreeInsert191To200AverageCost is PatriciaUtilsPerf, PatriciaTree {
    function perf() public payable returns (uint) {
        var pt = new PatriciaTree();
        bytes memory bts = new bytes(1);
        for (uint i = 0; i < 190; i++) {
            bts[0] = byte(i);
            insert(bts, bts);
        }
        uint aggregateGas = 0;
        for (i = 190; i < 200; i++) {
            bts[0] = byte(i);
            uint gasPre = msg.gas;
            insert(bts, bts);
            aggregateGas += gasPre - msg.gas;
        }
        return aggregateGas / uint(10);
    }
}
*/