pragma solidity ^0.4.16;
pragma experimental "v0.5.0";
pragma experimental "ABIEncoderV2";

import {Bits} from "../bits/Bits.sol";


/*
 * Data structures and utilities used in the Patricia Tree.
 *
 * More info at: https://github.com/chriseth/patricia-trie
 */
library Data {

    struct Label {
        bytes32 data;
        uint length;
    }

    struct Edge {
        bytes32 node;
        Label label;
    }

    struct Node {
        Edge[2] children;
    }

    struct Tree {
        bytes32 root;
        Data.Edge rootEdge;
        mapping(bytes32 => Data.Node) nodes;
    }

    // Returns a label containing the longest common prefix of `self` and `label`,
    // and a label consisting of the remaining part of `label`.
    function splitCommonPrefix(Label memory self, Label memory other) internal pure returns (
        Label memory prefix,
        Label memory labelSuffix
    ) {
        return splitAt(self, commonPrefix(self, other));
    }

    // Splits the label at the given position and returns prefix and suffix,
    // i.e. 'prefix.length == pos' and 'prefix.data . suffix.data == l.data'.
    function splitAt(Label memory self, uint pos) internal pure returns (Label memory prefix, Label memory suffix) {
        assert(pos <= self.length && pos <= 256);
        prefix.length = pos;
        if (pos == 0) {
            prefix.data = bytes32(0);
        } else {
            prefix.data = bytes32(uint(self.data) & ~uint(1) << 255 - pos);
        }
        suffix.length = self.length - pos;
        suffix.data = self.data << pos;
    }

    // Returns the length of the longest common prefix of the two labels.
    /*
    function commonPrefix(Label memory self, Label memory other) internal pure returns (uint prefix) {
        uint length = self.length < other.length ? self.length : other.length;
        // TODO: This could actually use a "highestBitSet" helper
        uint diff = uint(self.data ^ other.data);
        uint mask = uint(1) << 255;
        for (; prefix < length; prefix++) {
            if ((mask & diff) != 0) {
                break;
            }
            diff += diff;
        }
    }
    */

    function commonPrefix(Label memory self, Label memory other) internal pure returns (uint prefix) {
        uint length = self.length < other.length ? self.length : other.length;
        if (length == 0) {
            return 0;
        }
        uint diff = uint(self.data ^ other.data) & ~uint(0) << 256 - length; // TODO Mask should not be needed.
        if (diff == 0) {
            return length;
        }
        return 255 - Bits.highestBitSet(diff);
    }

    // Returns the result of removing a prefix of length `prefix` bits from the
    // given label (shifting its data to the left).
    function removePrefix(Label memory self, uint prefix) internal pure returns (Label memory r) {
        require(prefix <= self.length);
        r.length = self.length - prefix;
        r.data = self.data << prefix;
    }

    // Removes the first bit from a label and returns the bit and a
    // label containing the rest of the label (shifted to the left).
    function chopFirstBit(Label memory self) internal pure returns (uint firstBit, Label memory tail) {
        require(self.length > 0);
        return (uint(self.data >> 255), Label(self.data << 1, self.length - 1));
    }

    function edgeHash(Data.Edge memory self) internal pure returns (bytes32) {
        return keccak256(self.node, self.label.length, self.label.data);
    }

    // Returns the hash of the encoding of a node.
    function hash(Data.Node memory self) internal pure returns (bytes32) {
        return keccak256(edgeHash(self.children[0]), edgeHash(self.children[1]));
    }

    function insertNode(Data.Tree storage tree, Data.Node memory n) internal returns (bytes32 newHash) {
        bytes32 h = hash(n);
        tree.nodes[h].children[0] = n.children[0];
        tree.nodes[h].children[1] = n.children[1];
        return h;
    }

    function replaceNode(Data.Tree storage self, bytes32 oldHash, Data.Node memory n) internal returns (bytes32 newHash) {
        delete self.nodes[oldHash];
        return insertNode(self, n);
    }

    function insertAtEdge(Tree storage self, Edge e, Label key, bytes32 value) internal returns (Edge) {
        assert(key.length >= e.label.length);
        var (prefix, suffix) = splitCommonPrefix(key, e.label);
        bytes32 newNodeHash;
        if (suffix.length == 0) {
            // Full match with the key, update operation
            newNodeHash = value;
        } else if (prefix.length >= e.label.length) {
            // Partial match, just follow the path
            assert(suffix.length > 1);
            Node memory n = self.nodes[e.node];
            var (head, tail) = chopFirstBit(suffix);
            n.children[head] = insertAtEdge(self, n.children[head], tail, value);
            delete self.nodes[e.node];
            newNodeHash = insertNode(self, n);
        } else {
            // Mismatch, so let us create a new branch node.
            (head, tail) = chopFirstBit(suffix);
            Node memory branchNode;
            branchNode.children[head] = Edge(value, tail);
            branchNode.children[1 - head] = Edge(e.node, removePrefix(e.label, prefix.length + 1));
            newNodeHash = insertNode(self, branchNode);
        }
        return Edge(newNodeHash, prefix);
    }

    function insert(Tree storage self, bytes key, bytes value) internal {
        Label memory k = Label(keccak256(key), 256);
        bytes32 valueHash = keccak256(value);
        Edge memory e;
        if (self.root == 0) {
            // Empty Trie
            e.label = k;
            e.node = valueHash;
        } else {
            e = insertAtEdge(self, self.rootEdge, k, valueHash);
        }
        self.root = edgeHash(e);
        self.rootEdge = e;
    }
}