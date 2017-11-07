pragma solidity ^0.4.16;
pragma experimental "v0.5.0";
pragma experimental "ABIEncoderV2";

import {Data} from "./Data.sol";


/*
 * Interface for patricia trees.
 *
 * More info at: https://github.com/chriseth/patricia-trie
 */
contract PatriciaTreeFace {
    function getRootHash() public view returns (bytes32);
    function getRootEdge() public view returns (Data.Edge e);
    function getNode(bytes32 hash) public view returns (Data.Node n);
    function getProof(bytes key) public view returns (uint branchMask, bytes32[] _siblings);
    function verifyProof(bytes32 rootHash, bytes key, bytes value, uint branchMask, bytes32[] siblings) public view returns (bool);
    function insert(bytes key, bytes value) public;
}