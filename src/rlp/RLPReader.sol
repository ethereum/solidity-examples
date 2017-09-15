pragma solidity ^0.4.15;

import {Memory} from "../unsafe/Memory.sol";

/**
* @title RLPReader
*
* RLPReader is used to read and parse RLP encoded data in memory.
*
* TODO continue to clean up inline assembly
*
* @author Andreas Olofsson (androlo1980@gmail.com)
*
*/
library RLP {

    uint constant DATA_SHORT_START = 0x80;
    uint constant DATA_LONG_START = 0xB8;
    uint constant LIST_SHORT_START = 0xC0;
    uint constant LIST_LONG_START = 0xF8;

    uint constant DATA_LONG_OFFSET = 0xB7;
    uint constant LIST_LONG_OFFSET = 0xF7;

    struct RLPItem {
        uint _len;    // Number of bytes. This is the full length of the string.
        uint _ptr;    // Pointer to the RLP-encoded bytes.
    }

    struct Iterator {
        RLPItem _item;   // Item that's being iterated over.
        uint _nextPtr;   // Position of the next item in the list.
    }

    /* Iterator */

    function next(Iterator memory self) internal constant returns (RLPItem memory subItem) {
        require(hasNext(self));
        var ptr = self._nextPtr;
        var itemLength = _itemLength(ptr);
        subItem._ptr = ptr;
        subItem._len = itemLength;
        self._nextPtr = ptr + itemLength;
    }

    function next(Iterator memory self, bool strict) internal constant returns (RLPItem memory subItem) {
        subItem = next(self);
        require(!strict || _validate(subItem));
    }

    function hasNext(Iterator memory self) internal constant returns (bool) {
        var item = self._item;
        return self._nextPtr < item._ptr + item._len;
    }

    /* RLPItem */

    /// @dev Creates an RLPItem from an array of RLP encoded bytes.
    /// @param self The RLP encoded bytes.
    /// @return An RLPItem
    function toRLPItem(bytes memory self) internal constant returns (RLPItem memory item) {
        require(self.length > 0);
        var mem = Memory.fromBytes(self);
        assembly {
            item := mem
        }
    }

    /// @dev Creates an RLPItem from an array of RLP encoded bytes.
    /// @param self The RLP encoded bytes.
    /// @param strict Will throw if the data is not RLP encoded.
    /// @return An RLPItem
    function toRLPItem(bytes memory self, bool strict) internal constant returns (RLPItem memory) {
        var item = toRLPItem(self);
        if (strict) {
            uint len = self.length;
            require(_payloadOffset(item) <= len && _itemLength(item._ptr) == len && _validate(item));
        }
        return item;
    }

    /// @dev Check if the RLP item is a list.
    /// @param self The RLP item.
    /// @return 'true' if the item is a list.
    function isList(RLPItem memory self) internal constant returns (bool ret) {
        uint ptr = self._ptr;
        assembly {
            ret := iszero(lt(byte(0, mload(ptr)), 0xC0))
        }
    }

    /// @dev Check if the RLP item is data.
    /// @param self The RLP item.
    /// @return 'true' if the item is data.
    function isData(RLPItem memory self) internal constant returns (bool ret) {
        uint ptr = self._ptr;
        assembly {
            ret := lt(byte(0, mload(ptr)), 0xC0)
        }
    }

    /// @dev Check if the RLP item is empty (string or list).
    /// @param self The RLP item.
    /// @return 'true' if the item is null.
    function isEmpty(RLPItem memory self) internal constant returns (bool ret) {
        uint b0;
        uint ptr = self._ptr;
        assembly {
            b0 := byte(0, mload(ptr))
        }
        return (b0 == DATA_SHORT_START || b0 == LIST_SHORT_START);
    }

    /// @dev Get the number of items in an RLP encoded list.
    /// @param self The RLP item.
    /// @return The number of items.
    function items(RLPItem memory self) internal constant returns (uint) {
        require(isList(self));
        uint b0;
        uint ptr = self._ptr;
        assembly {
            b0 := byte(0, mload(ptr))
        }
        uint pos = ptr + _payloadOffset(self);
        uint last = ptr + self._len - 1;
        uint itms;
        while (pos <= last) {
            pos += _itemLength(pos);
            itms++;
        }
        return itms;
    }

    /// @dev Create an iterator.
    /// @param self The RLP item.
    /// @return An 'Iterator' over the item.
    function iterator(RLPItem memory self) internal constant returns (Iterator memory it) {
        require(isList(self));
        uint ptr = self._ptr + _payloadOffset(self);
        it._item = self;
        it._nextPtr = ptr;
    }

    /// @dev Return the RLP encoded bytes.
    /// @param self The RLPItem.
    /// @return The bytes.
    function toBytes(RLPItem memory self) internal constant returns (bytes memory bts) {
        Memory.Array memory mArr;
        assembly {
            mArr := self
        }
        bts = Memory.toBytes(mArr);
    }

    /// @dev Decode an RLPItem into bytes. This will not work if the
    /// RLPItem is a list.
    /// @param self The RLPItem.
    /// @return The decoded string.
    function toData(RLPItem memory self) internal constant returns (bytes memory bts) {
        require(isData(self));
        var (rStartPos, len) = _decode(self);
        bts = Memory.toBytes(Memory.Array(len, rStartPos));
    }

    /// @dev Decode an RLPItem into a string. This will not work if the
    /// RLPItem is a list.
    /// @param self The RLPItem.
    /// @return The decoded string.
    function toString(RLPItem memory self) internal constant returns (string memory str) {
        require(isData(self));
        var (rStartPos, len) = _decode(self);
        str = Memory.toString(Memory.Array(len, rStartPos));
    }

    /// @dev Decode an RLPItem into a uint. This will not work if the
    /// RLPItem is a list.
    /// @param self The RLPItem.
    /// @return The decoded string.
    function toUint(RLPItem memory self) internal constant returns (uint data) {
        require(isData(self));
        var (rStartPos, len) = _decode(self);
        require(len > 0 && len <= 32);
        assembly {
            data := div(mload(rStartPos), exp(256, sub(32, len)))
        }
    }

    /// @dev Decode an RLPItem into a boolean. This will not work if the
    /// RLPItem is a list.
    /// @param self The RLPItem.
    /// @return The decoded string.
    function toBool(RLPItem memory self) internal constant returns (bool data) {
        require(isData(self));
        var (rStartPos, len) = _decode(self);
        require(len == 1);
        uint temp;
        assembly {
            temp := byte(0, mload(rStartPos))
        }
        require(temp <= 1);
        return temp == 1 ? true : false;
    }

    /// @dev Decode an RLPItem into a byte. This will not work if the
    /// RLPItem is a list.
    /// @param self The RLPItem.
    /// @return The decoded string.
    function toByte(RLPItem memory self) internal constant returns (byte data) {
        require(isData(self));
        var (rStartPos, len) = _decode(self);
        require(len == 1);
        uint temp;
        assembly {
            temp := byte(0, mload(rStartPos))
        }
        return byte(temp);
    }

    /// @dev Decode an RLPItem into an int. This will not work if the
    /// RLPItem is a list.
    /// @param self The RLPItem.
    /// @return The decoded string.
    function toInt(RLPItem memory self) internal constant returns (int data) {
        data = int(toUint(self));
    }

    /// @dev Decode an RLPItem into a bytes32. This will not work if the
    /// RLPItem is a list.
    /// @param self The RLPItem.
    /// @return The decoded string.
    function toBytes32(RLPItem memory self) internal constant returns (bytes32 data) {
        data = bytes32(toUint(self));
    }

    /// @dev Decode an RLPItem into an address. This will not work if the
    /// RLPItem is a list.
    /// @param self The RLPItem.
    /// @return The decoded string.
    function toAddress(RLPItem memory self) internal constant returns (address data) {
        require(isData(self));
        var (rStartPos, len) = _decode(self);
        require(len == 20);
        assembly {
            data := div(mload(rStartPos), exp(256, 12))
        }
    }

    // Get the payload offset.
    function _payloadOffset(RLPItem memory self) private constant returns (uint) {
        uint b0;
        uint ptr = self._ptr;
        assembly {
            b0 := byte(0, mload(ptr))
        }
        if (b0 < DATA_SHORT_START) {
            return 0;
        }
        if (b0 < DATA_LONG_START || (b0 >= LIST_SHORT_START && b0 < LIST_LONG_START)) {
            return 1;
        }
        if (b0 < LIST_SHORT_START) {
            return b0 - DATA_LONG_OFFSET + 1;
        }
        return b0 - LIST_LONG_OFFSET + 1;
    }

    // Get the full length of an RLP item.
    function _itemLength(uint memPtr) private constant returns (uint len) {
        uint b0;
        assembly {
            b0 := byte(0, mload(memPtr))
        }
        if (b0 < DATA_SHORT_START)
            len = 1;
        else if (b0 < DATA_LONG_START)
            len = b0 - DATA_SHORT_START + 1;
        else if (b0 < LIST_SHORT_START) {
            assembly {
                let bLen := sub(b0, 0xB7) // bytes length (DATA_LONG_OFFSET)
                let dLen := div(mload(add(memPtr, 1)), exp(256, sub(32, bLen))) // data length
                len := add(1, add(bLen, dLen)) // total length
            }
        } else if (b0 < LIST_LONG_START) {
            len = b0 - LIST_SHORT_START + 1;
        } else {
            assembly {
                let bLen := sub(b0, 0xF7) // bytes length (LIST_LONG_OFFSET)
                let dLen := div(mload(add(memPtr, 1)), exp(256, sub(32, bLen))) // data length
                len := add(1, add(bLen, dLen)) // total length
            }
        }
    }

    // Get start position and length of the data.
    function _decode(RLPItem memory self) private constant returns (uint memPtr, uint len) {
        require(isData(self));
        uint b0;
        uint start = self._ptr;
        assembly {
            b0 := byte(0, mload(start))
        }
        if (b0 < DATA_SHORT_START) {
            memPtr = start;
            len = 1;
            return;
        }
        if (b0 < DATA_LONG_START) {
            len = self._len - 1;
            memPtr = start + 1;
        } else {
            uint bLen;
            assembly {
                bLen := sub(b0, 0xB7) // DATA_LONG_OFFSET
            }
            len = self._len - 1 - bLen;
            memPtr = start + bLen + 1;
        }
        return;
    }

    // Check that an RLP item is valid.
    function _validate(RLPItem memory self) private constant returns (bool ret) {
        // Check that RLP is well-formed.
        uint b0;
        uint b1;
        uint ptr = self._ptr;
        assembly {
            b0 := byte(0, mload(ptr))
            b1 := byte(1, mload(ptr))
        }
        if (b0 == DATA_SHORT_START + 1 && b1 < DATA_SHORT_START)
            return false;
        return true;
    }

}