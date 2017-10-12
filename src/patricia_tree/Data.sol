pragma solidity ^0.4.16;
pragma experimental "v0.5.0";
pragma experimental "ABIEncoderV2";


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

    /// Returns a label containing the longest common prefix of `self` and `label`
    /// and a label consisting of the remaining part of `label`.
    function splitCommonPrefix(Label memory self, Label memory label) internal pure returns (
        Label memory prefix,
        Label memory labelSuffix
    ) {
        return splitAt(self, commonPrefix(label, self));
    }

    /// Splits the label at the given position and returns prefix and suffix,
    /// i.e. prefix.length == pos and prefix.data . suffix.data == l.data.
    function splitAt(Label memory self, uint pos) internal pure returns (Label memory prefix, Label memory suffix) {
        require(pos <= self.length && pos <= 256);
        prefix.length = pos;
        if (pos == 0) {
            prefix.data = bytes32(0);
        } else {
            prefix.data = self.data & ~bytes32((uint(1) << (256 - pos)) - 1);
        }
        suffix.length = self.length - pos;
        suffix.data = self.data << pos;
    }

    /// Returns the length of the longest common prefix of the two labels.
    function commonPrefix(Label memory self, Label memory lbl) internal pure returns (uint prefix) {
        uint length = self.length < lbl.length ? self.length : lbl.length;
        // TODO: This could actually use a "highestBitSet" helper
        uint diff = uint(self.data ^ lbl.data);
        uint mask = uint(1) << 255;
        for (; prefix < length; prefix++) {
            if ((mask & diff) != 0) {
                break;
            }
            diff += diff;
        }
    }

    /// Returns the result of removing a prefix of length `prefix` bits from the
    /// given label (i.e. shifting its data to the left).
    function removePrefix(Label memory self, uint prefix) internal pure returns (Label memory r) {
        require(prefix <= self.length);
        r.length = self.length - prefix;
        r.data = self.data << prefix;
    }

    /// Removes the first bit from a label and returns the bit and a
    /// label containing the rest of the label (i.e. shifted to the left).
    function chopFirstBit(Label memory self) internal pure returns (uint firstBit, Label memory tail) {
        require(self.length > 0);
        return (uint(self.data >> 255), Label(self.data << 1, self.length - 1));
    }

}