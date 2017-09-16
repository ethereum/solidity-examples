pragma solidity ^0.4.0;

contract PatriciaTree {
    function getNode(bytes32 hash) constant returns (uint, bytes32, bytes32, uint, bytes32, bytes32);
    function getRootEdge() constant returns (uint, bytes32, bytes32);
    function getProof(bytes key) constant returns (uint branchMask, bytes32[] _siblings);
    function verifyProof(bytes32 rootHash, bytes key, bytes value, uint branchMask, bytes32[] siblings) constant returns (bool);
    function insert(bytes key, bytes value);
}