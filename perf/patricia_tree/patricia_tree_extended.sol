pragma solidity ^0.4.16;
pragma experimental "v0.5.0";
pragma experimental "ABIEncoderV2";

import {Data} from "../../src/patricia_tree/Data.sol";
import {PatriciaTree} from "../../src/patricia_tree/PatriciaTree.sol";
import {PatriciaTreeDataPerf} from "./patricia_tree.sol";


contract PerfPatriciaTreeGetProof1To10AverageCost is PatriciaTreeDataPerf, PatriciaTree {
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


contract PerfPatriciaTreeGetProof91To100AverageCost is PatriciaTreeDataPerf, PatriciaTree {
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


contract PerfPatriciaTreeGetProof191To200AverageCost is PatriciaTreeDataPerf, PatriciaTree {
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

contract PerfPatriciaTreeValidateProof1To10AverageCost is PatriciaTreeDataPerf, PatriciaTree {
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


contract PerfPatriciaTreeValidateProof91To100AverageCost is PatriciaTreeDataPerf, PatriciaTree {
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


contract PerfPatriciaTreeValidateProof191To200AverageCost is PatriciaTreeDataPerf, PatriciaTree {
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


contract PerfPatriciaTreeInsert1To10AverageCost is PatriciaTreeDataPerf, PatriciaTree {
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


contract PerfPatriciaTreeInsert91To100AverageCost is PatriciaTreeDataPerf, PatriciaTree {
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


contract PerfPatriciaTreeInsert191To200AverageCost is PatriciaTreeDataPerf, PatriciaTree {
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