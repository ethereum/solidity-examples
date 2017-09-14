pragma solidity ^0.4.0;

import {Data} from "./Data.sol";
import {Bits} from "../bits/Bits.sol";

contract PatriciaTree {

    using Data for Data.Node;
    using Data for Data.Edge;
    using Data for Data.Label;
    using Bits for uint;

    // Particia tree nodes (hash to decoded contents)
    mapping (bytes32 => Data.Node) nodes;
    // The current root hash, keccak256(node(path_M('')), path_M(''))
    bytes32 public root;
    Data.Edge rootEdge;

    function getNode(bytes32 hash) constant returns (uint, bytes32, bytes32, uint, bytes32, bytes32) {
        var n = nodes[hash];
        return (
            n.children[0].label.length, n.children[0].label.data, n.children[0].node,
            n.children[1].label.length, n.children[1].label.data, n.children[1].node
        );
    }

    function getRootEdge() constant returns (uint, bytes32, bytes32) {
        return (rootEdge.label.length, rootEdge.label.data, rootEdge.node);
    }

    function edgeHash(Data.Edge e) constant internal returns (bytes32) {
        return keccak256(e.node, e.label.length, e.label.data);
    }

    // Returns the hash of the encoding of a node.
    function hash(Data.Node memory n) constant internal returns (bytes32) {
        return keccak256(edgeHash(n.children[0]), edgeHash(n.children[1]));
    }


    // Returns the Merkle-proof for the given key
    // Proof format should be:
    //  - uint branchMask - bitmask with high bits at the positions in the key
    //                    where we have branch nodes (bit in key denotes direction)
    //  - bytes32[] hashes - hashes of sibling edges
    function getProof(bytes key) constant returns (uint branchMask, bytes32[] _siblings) {
        require(root != 0);
        Data.Label memory k = Data.Label(keccak256(key), 256);
        Data.Edge memory e = rootEdge;
        bytes32[256] memory siblings;
        uint length;
        uint numSiblings;
        while (true) {
            var (prefix, suffix) = k.splitCommonPrefix(e.label);
            require(prefix.length == e.label.length);
            if (suffix.length == 0) {
                // Found it
                break;
            }
            length += prefix.length;
            branchMask |= uint(1) << (255 - length);
            length += 1;
            var (head, tail) = suffix.chopFirstBit();
            siblings[numSiblings++] = edgeHash(nodes[e.node].children[1 - head]);
            e = nodes[e.node].children[head];
            k = tail;
        }
        if (numSiblings > 0) {
            _siblings = new bytes32[](numSiblings);
            for (uint i = 0; i < numSiblings; i++) {
                _siblings[i] = siblings[i];
            }
        }
    }

    function verifyProof(bytes32 rootHash, bytes key, bytes value, uint branchMask, bytes32[] siblings) constant returns (bool) {
        Data.Label memory k = Data.Label(keccak256(key), 256);
        Data.Edge memory e;
        e.node = keccak256(value);
        for (uint i = 0; branchMask != 0; i++) {
            uint bitSet = branchMask.lowestBitSet();
            branchMask &= ~(uint(1) << bitSet);
            (k, e.label) = k.splitAt(255 - bitSet);
            uint bit;
            (bit, e.label) = e.label.chopFirstBit();
            bytes32[2] memory edgeHashes;
            edgeHashes[bit] = edgeHash(e);
            edgeHashes[1 - bit] = siblings[siblings.length - i - 1];
            e.node = keccak256(edgeHashes);
        }
        e.label = k;
        require(rootHash == edgeHash(e));
        return true;
    }

    function insert(bytes key, bytes value) {
        Data.Label memory k = Data.Label(keccak256(key), 256);
        bytes32 valueHash = keccak256(value);
        // keys.push(key);
        Data.Edge memory e;
        if (rootEdge.node == 0 && rootEdge.label.length == 0) {
            // Empty Trie
            e.label = k;
            e.node = valueHash;
        } else {
            e = insertAtEdge(rootEdge, k, valueHash);
        }
        root = edgeHash(e);
        rootEdge = e;
    }

    function insertAtNode(bytes32 nodeHash, Data.Label key, bytes32 value) internal returns (bytes32) {
        require(key.length > 1);
        Data.Node memory n = nodes[nodeHash];
        var (head, tail) = key.chopFirstBit();
        n.children[head] = insertAtEdge(n.children[head], tail, value);
        return replaceNode(nodeHash, n);
    }

    function insertAtEdge(Data.Edge e, Data.Label key, bytes32 value) internal returns (Data.Edge) {
        require(key.length >= e.label.length);
        var (prefix, suffix) = key.splitCommonPrefix(e.label);
        bytes32 newNodeHash;
        if (suffix.length == 0) {
            // Full match with the key, update operation
            newNodeHash = value;
        } else if (prefix.length >= e.label.length) {
            // Partial match, just follow the path
            newNodeHash = insertAtNode(e.node, suffix, value);
        } else {
            // Mismatch, so let us create a new branch node.
            var (head, tail) = suffix.chopFirstBit();
            Data.Node memory branchNode;
            branchNode.children[head] = Data.Edge(value, tail);
            branchNode.children[1 - head] = Data.Edge(e.node, e.label.removePrefix(prefix.length + 1));
            newNodeHash = insertNode(branchNode);
        }
        return Data.Edge(newNodeHash, prefix);
    }

    function insertNode(Data.Node memory n) internal returns (bytes32 newHash) {
        bytes32 h = hash(n);
        nodes[h].children[0] = n.children[0];
        nodes[h].children[1] = n.children[1];
        return h;
    }

    function replaceNode(bytes32 oldHash, Data.Node memory n) internal returns (bytes32 newHash) {
        delete nodes[oldHash];
        return insertNode(n);
    }
}