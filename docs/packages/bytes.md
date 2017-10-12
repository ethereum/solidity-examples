# Bytes

#### Type: Internal library

The `Bytes` library has functions for working with bytes.

Example usage: [BytesExamples.sol](../../examples/bytes/BytesExamples.sol)

#### Bytes, strings, numbers and endianness in Ethereum

Ethereum uses the big endian format when working with strings/bytes, and little endian when working with other types (such as numbers and addresses). As an example, this is how we would store the string "abcd" in one full word (32 bytes):

`0x6162636400000000000000000000000000000000000000000000000000000000`

This is how the number `0x61626364` would be stored:

`0x0000000000000000000000000000000000000000000000000000000061626364`

Solidity has built-in support for this, and will automatically use the correct byte order depending on the type. The `web3.js` javascript API has a very good built in support for this as well, and padding is normally done automatically when javascript values are being encoded and decoded.

##### Using strings and hex-literals with fixed size bytes

Byte order is important when working with literals. `bytesN` will use different internal representations for different types of literals.

1. Number literals assigned to `bytesN` variables are padded to the left.
2. String literals assigned to `bytesN` variables are padded to the right.

```
// 0x0000000000000000000000000000000000000000000000000000000001020304
var nl = bytes32(0x01020304);

// 0x3031303230333034000000000000000000000000000000000000000000000000
var sl = bytes32("01020304");
```

##### Index access in fixed size bytes

Accessing individual bytes by index is possible for all `bytes/bytesN` types. The highest order byte is found at index `0`.

```
var nl0 = nl[0]; // 0
var nl31 = nl[31]; // 0x04

var sl0 = sl[0]; // 0x30
var sl31 = sl[31]; // 0
```


##### Using `byte` in assembly

The `byte(index, data)` instruction will read the byte at position `index` from an item `data`, and put it on the stack. The range of `index` is `[0, 31]`.

```
uint nl0;
uint nl31;
assembly {
    x := byte(0, nl)
    x := byte(31, nl)
}
// nl0 = 0
// nl31 = 4
```

The `byte` instruction does not create a value that is compatible with the `byte/bytes1` type, however. More about this in the next section.

##### The `byte` (`bytes1`) type

The `byte` type, which is an alias for `bytes1`, stores a single byte. This means it does not matter if the value provided is a string or number literal (of size one byte). A `byte` is still different from a number type of the same bit-size though, like for example `uint8`, because their internal representations of that byte are different.

```
// 0x0000000000000000000000000000000000000000000000000000000000000001
uint8 u8 = 1;

// 0x0100000000000000000000000000000000000000000000000000000000000000
byte b = 1;
```

This is important when converting between different types - especially when inline assembly is involved.

```
bytes32 b32 = "Terry A. Davis";
byte b;
assembly {
    b := byte(0, b32)
}
```

What is the value of `b` after this code has been run?

The value will be `0`, but the internal representation would be `0x0000000000000000000000000000000000000000000000000000000000000001`, which lies outside of the allowed range so is technically invalid.

Finally, **note** that these sections deal with bytes in memory and on the stack. For bytes packed in storage, things can be different.

## Functions

- [equals(bytes memory, bytes memory)](#equals)
- [equalsRef(bytes memory, bytes memory)](#equalsRef)
- [copy(bytes memory)](#copy)
- [substr(bytes memory, uint)](#substrBytes)
- [substr(bytes memory, uint, uint)](#substrBytes2)
- [substr(bytes32, uint8)](#substrBytes32)
- [substr(bytes32, uint8, uint8)](#substrBytes322)
- [concat(bytes memory, bytes memory)](#concat)
- [toBytes(bytes32)](#toBytes)
- [toBytes(bytes32, uint8)](#toBytes2)
- [toBytes(address)](#toBytesAddr)
- [toBytes(uint)](#toBytesUint)
- [toBytes(uint, uint16)](#toBytesUint2)
- [toBytes(bool)](#toBytesBool)
- [highestByteSet(bytes32)](#highestByteSetBytes32)
- [lowestByteSet(bytes32)](#lowestByteSetBytes32)
- [highestByteSet(uint)](#highestByteSetUint)
- [lowestByteSet(uint)](#lowestByteSetUint)

### <a name="equals"/>equals(bytes memory, bytes memory)

`function equals(bytes memory self, bytes memory other) internal pure returns (bool equal)`

##### description

Checks if two `bytes memory` are equal. This is a more efficient method then checking each index manually.

##### input parameters

`bytes memory self` - The first bytes.

`bytes memory other` - The second bytes.

##### returns

`true` if the two `bytes memory` are equal, otherwise `false`.

##### ensures

`bts.equals(bts2) => bts.length == bts2.length`

`bts.equals(bts2) => for each index i in [0, bts.length), bts[i] == bts2[i]`

***

### <a name="equalsRef"/>equalsRef(bytes memory, bytes memory)

`function equalsRef(bytes memory self, bytes memory other) internal pure returns (bool equal)`

##### description

Checks if two `bytes memory` are the same by comparing their internal references.

##### input parameters

`bytes memory self` - The first bytes.

`bytes memory other` - The second bytes.

##### returns

`true` if the two `bytes memory` references the same address in memory, otherwise false.

##### ensures

`bts.equalsRef(bts2) => bts.equals(bts2)`

`bts.equalsRef(bts2) => (bts[i] = x <=> bts2[i] = x), i in [0, bts.length)` (mutating one affects both)

***

### <a name="copy"/>copy(bytes memory)

`function copy(bytes memory self) internal pure returns (bytes memory);`

##### description

Copies a `bytes memory` array.

##### input parameters

`bytes memory self` - The first bytes.

##### returns

The copy.

##### ensures

`cpy = self.copy() => cpy.equals(self)`

`cpy = self.copy() => !cpy.equalsRef(self)`

***

### <a name="substrBytes2/>substr(bytes memory, uint)

`function substr(bytes memory self, uint startIdx) internal pure returns (bytes memory);`

##### description

Same as `copy(bytes memory)` but starts copying at position `startIdx`.

Calling `bts.copy()` is the same as calling `bts.substr(0)`.

##### input parameters

`bytes memory self` - The bytes to copy.

`uint startIdx` - The index to start copying from.

##### requires

`startIndex < self.length`

##### returns

The copy.

##### ensures

`sst = self.substr(startIndex) => sst.length = self.length - startIndex`.

```
sst = self.substr(startIndex) =>
sst[0] = self[startIdx]
sst[1] = self[startIdx + 1]
...
sst[cpy.length - 1] = self[self.length - 1]`.
```

***

### <a name="substrBytes2"/>substr(bytes memory, uint, uint)

`function substr(bytes memory self, uint startIdx, uint len) internal pure returns (bytes memory);`

##### description

This function copies `len` number of bytes from `self`, starting at `startIndex`.

Calling `bts.copy()` is the same as calling `bts.substr(0, bts.length)`.

##### input parameters

`bytes memory self` - The source bytes.

`uint startIdx` - The index to start copying from.

`uint len` - The number of bytes to copy.

##### requires

`startIdx < self.length`

`startIdx + len <= self.length`.

##### returns

The copy.

##### ensures

`sst = self.substr(startIndex, len) => sst.length = len`.

```
sst = self.copy(startIndex, len) =>
sst[0] = self[startIdx]
sst[1] = self[startIdx + 1]
...
sst[len - 1] = self[startIdx + len - 1]`.
```

***

#### <a name="concat"/>concat(bytes memory, bytes memory)

`function concat(bytes memory self, bytes memory other) internal pure returns (bytes memory)`

##### description

Concatenates two `bytes memory` arrays into one single array.

This function works with 0-length bytes as well.

##### input parameters

`bytes memory self` - The first bytes to concatenate.

`bytes memory self` - The second bytes to concatenate.

##### returns

The concatenated bytes.

##### ensures

`btsCnct = self.concat(other) => btsCnct.length == self.length + other.length`

```
btsCnct = self.concat(other) =>
btsCnct[0] = self[0]
btsCnct[1] = self[1]
...
btsCnct[self.length - 1] = self[self.length - 1]
btsCnct[self.length] = other[0]
btsCnct[self.length + 1] = other[1]
...
btsCnct[self.length + other.length - 1] = other[other.length - 1]
```

***

### <a name="substrBytes32/>substr(bytes32, uint8)

`function substr(bytes32 self, uint8 startIndex) internal pure returns (bytes32);`

##### description

Create a substring of a `bytes32`, starting at `startIndex`.

##### input parameters

`bytes32 self` - The source bytes.

`uint8 startIdx` - The index to start copying from.

##### requires

`startIndex < 32`

##### returns

The substring as a new `bytes32`

##### ensures

`sst = self.substr(startIndex) => sst.length = self.length - startIndex`.

```
sst = self.substr(startIndex) => for i in [0, 32 - startIndex), sst[i] == self[startIndex + i],
                                 for i in [32 - startIndex, 32), sst[i] == 0
```

***

### <a name="substrBytes322/>substr(bytes32, uint8, uint8)

`function substr(bytes32 self, uint8 startIndex, uint8 len) internal pure returns (bytes32);`

##### description

Create a substring of a `bytes32`, starting at `startIndex`.

##### input parameters

`bytes32 self` - The source bytes.

`uint8 startIndex` - The index to start copying from.

`uint8 len` - The length.

##### requires

`startIndex < 32`

`startIndex + len <= 32`

##### returns

The substring as a new `bytes32`

##### ensures

`sst = self.substr(startIndex) => sst.length = len`.

```
sst = self.substr(startIndex) => for i in [0, len), sst[i] == self[startIndex + i],
                                 for i in [len, 32), sst[i] == 0
```

***

### <a name="toBytes"/>toBytes(bytes32)

`function toBytes(bytes32 b32) internal pure returns (bytes memory bts)`

##### description

Create a new `bytes memory` from a `bytes32`. The function will only include the bytes up to the highest byte set.

##### input parameters

`bytes32 self` - The bytes to convert.

##### requires

`self != 0`

##### returns

The bytes as a `bytes memory`.

##### ensures

`bts = self.toBytes() => bts.length = self.highestByteSet() + 1`


`bts = self.toBytes() => bts[i] = self[i], for i in [0, bts.length]`

***

### <a name="toBytesBytes32"/>toBytes(bytes32)

`function toBytes(bytes32 b32) internal pure returns (bytes memory bts)`

##### description

Create a new `bytes memory` from a `bytes32`. The function will only include the bytes up to the highest byte set.

##### input parameters

`bytes32 self` - The bytes to convert.

##### requires

`self != 0`

##### returns

The bytes as a `bytes memory`.

##### ensures

`bts = self.toBytes() => bts.length = self.highestByteSet() + 1`

`bts = self.toBytes() => bts[i] = self[i], for i in [0, bts.length)`

***

### <a name="toBytesBytes322"/>toBytes(bytes32, uint8)

`function toBytes(bytes32 b32, uint8 startIndex) internal pure returns (bytes memory bts)`

##### description

Create a new `bytes memory` from a `bytes32`. The function will include the bytes from `startIndex` to the highest byte set.

##### input parameters

`bytes32 self` - The bytes to convert.

##### requires

`self != 0`

##### returns

The bytes as a `bytes memory`.

##### ensures

`bts = self.toBytes() => bts.length = self.highestByteSet() + 1`


`bts = self.toBytes() => bts[i] = self[i], for i in [0, bts.length]`











### <a name="highestByteSetBytes32"/>highestByteSet(bytes32)

`highestByteSet(bytes32 self) internal pure returns (uint8 highest)`

##### description

Get the index of the highest byte set in `self`, using the big-endian byte order.

##### input parameters

`bytes32 self` - The bytes to check.

##### requires

`self != 0`

##### returns

The index of the highest byte set in `self` as a `uint8`.

##### ensures

`hbs = self.highestByteSet() => for all i > hbs, self[i] == 0`

***

### <a name="lowestByteSetBytes32"/>lowestByteSet(bytes32)

`lowestByteSet(bytes32 self) internal pure returns (uint8 lowest)`

##### description

Get the index of the lowest byte set in `self`, using the big-endian byte order.

##### input parameters

`bytes32 self` - The bytes to check.

##### requires

`self != 0`

##### returns

The index of the lowest byte set in `self` as a `uint8`.

##### ensures

`lbs = self.lowestByteSet() => for all i < hbs, self[i] == 0`

***

### <a name="highestByteSetUint"/>highestByteSet(uint)

`highestByteSet(uint self) internal pure returns (uint8 highest)`

##### description

Get the index of the highest byte set in `self`, using the little-endian byte order.

##### input parameters

`uint self` - The unsigned integer to check.

##### requires

`self != 0`

##### returns

The index of the highest byte set in `self` as a `uint8`.

##### ensures

`hbs = self.highestByteSet() => self >> (hbs + 1)*8 == 0`
