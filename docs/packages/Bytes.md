# Bytes



**Package:** bytes

**Contract type:** Static library

**Source file:** [Bytes.sol](../../src/bytes/Bytes.sol)

**Example usage:** [BytesExamples.sol](../../examples/bytes/BytesExamples.sol)

**Tests source file:** [bytes_tests.sol](../../test/bytes/bytes_tests.sol)

**Perf (gas usage) source file:** [bytes_perfs.sol](../../perf/bytes/bytes_perfs.sol)


## description

The `Bytes` library has functions for working with bytes.

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

The value will be `0`, but the internal representation would be `0x0000000000000000000000000000000000000000000000000000000000000054`, which lies outside of the allowed range so is technically invalid.

Finally, **note** that these sections deal with bytes in memory and on the stack. For bytes packed in storage, things can be different.


## Functions

- [equals(bytes memory, bytes memory)](#equalsbytes-memory-bytes-memory)
- [equalsRef(bytes memory, bytes memory)](#equalsrefbytes-memory-bytes-memory)
- [copy(bytes memory)](#copybytes-memory)
- [substr(bytes memory, uint)](#substrbytes-memory-uint)
- [substr(bytes memory, uint, uint)](#substrbytes-memory-uint-uint)
- [concat(bytes memory, bytes memory)](#concatbytes-memory-bytes-memory)
- [substr(bytes32, uint8)](#substrbytes32-uint8)
- [substr(bytes32, uint8, uint8)](#substrbytes32-uint8-uint8)
- [toBytes(bytes32)](#tobytesbytes32)
- [toBytes(bytes32, uint8)](#tobytesbytes32-uint8)
- [toBytes(address)](#tobytesaddress)
- [toBytes(uint)](#tobytesuint)
- [toBytes(uint, uint16)](#tobytesuint-uint16)
- [toBytes(bool)](#tobytesbool)
- [highestByteSet(bytes32)](#highestbytesetbytes32)
- [lowestByteSet(bytes32)](#lowestbytesetbytes32)
- [highestByteSet(uint)](#highestbytesetuint)
- [lowestByteSet(uint)](#lowestbytesetuint)

***

### equals(bytes memory, bytes memory)

`function equals(bytes memory self, bytes memory other) internal pure returns (bool)`

Checks if two `bytes memory` are equal. This is a more efficient method then checking each index manually.

##### params

- `bytes memory self`: The first bytes.
- `bytes memory other`: The second bytes.


##### returns

- `bool`: `true` if the two `bytes memory` are equal, otherwise `false`.

##### ensures

- `bts.equals(bts2) => bts.length == bts2.length`
- `bts.equals(bts2) => for i in [0, bts.length): bts[i] == bts2[i]`
##### gascosts

- One word: **277**
- Ten words: **412**
- Early out on different lengths: **116**

***

### equalsRef(bytes memory, bytes memory)

`function equalsRef(bytes memory self, bytes memory other) internal pure returns (bool)`

Checks if two `bytes memory` are the same by comparing their internal references.

##### params

- `bytes memory self`: The first bytes.
- `bytes memory other`: The second bytes.


##### returns

- `bool`: `true` if the two `bytes memory` are equal, otherwise `false`.

##### ensures

- `bts.equalsRef(bts2) => bts.equals(bts2)`
- `bts.equalsRef(bts2) => for i in [0, bts.length): bts[i] = x <=> bts2[i] = x` (mutating one affects both)
##### gascosts

- Fixed: **66**

***

### copy(bytes memory)

`function copy(bytes memory self) internal pure returns (bytes)`

Copies a `bytes memory` array.

##### params

- `bytes memory self`: The source bytes.


##### returns

- `bytes`: The copy.

##### ensures

- `cpy = self.copy() => cpy.equals(self)`
- `cpy = self.copy() => !cpy.equalsRef(self)`
- `cpy = self.copy() => for i in [0, self.length): cpy[i] == self[i]`
##### gascosts

- Copy empty bytes: **157**
- Copy one word: **827**
- Copy ten words: **2785**

***

### substr(bytes memory, uint)

`function substr(bytes memory self, uint startIndex) internal pure returns (bytes)`

Same as `copy(bytes memory)` but starts copying at position `startIndex`.

##### params

- `bytes memory self`: The source bytes.
- `uint startIndex`: The index to start copying from.

##### requires

- `startIndex < self.length`

##### returns

- `bytes`: The copied bytes.

##### ensures

- `sst = self.substr(startIndex) => sst.length = self.length - startIndex`.
- `sst = self.substr(startIndex) => sst = [self[startIdx], self[startIdx + 1], ... , self[self.length - 1]]`.
##### gascosts

- Copy one word: **883**

***

### substr(bytes memory, uint, uint)

`function substr(bytes memory self, uint startIndex, uint len) internal pure returns (bytes)`

This function copies `len` number of bytes from `self`, starting at `startIndex`.

Calling `bts.copy()` is the same as calling `bts.substr(0, bts.length)`.

##### params

- `bytes memory self`: The source bytes.
- `uint startIndex`: The index to start copying from.
- `uint len`: The number of bytes to copy.

##### requires

- `startIndex < self.length`
- `startIndex + len <= self.length`.

##### returns

- `bytes`: The copied bytes.

##### ensures

- `sst = self.substr(startIndex, len) => sst.length = len`.
- `sst = self.copy(startIndex, len) => sst = [self[startIdx], self[startIdx + 1], ... , self[startIdx + len - 1]]`.
##### gascosts

- Copy one word: **939**

***

### concat(bytes memory, bytes memory)

`function concat(bytes memory self, bytes memory other) internal pure returns (bytes memory)`

Concatenates two `bytes memory` arrays into one single array.

##### params

- `bytes memory self`: The first bytes.
- `bytes memory other`: The second bytes.


##### returns

- `bytes memory`: The concatenated bytes.

##### ensures

- `btsCnct = self.concat(other) => btsCnct.length == self.length + other.length`.
- `btsCnct = self.concat(other) => btsCnct = [self[0], self[1], ... , self[self.length - 1], other[0], other[1], ... , other[other.length - 1]]`.
##### gascosts

- Concat two empty bytes: **986**
- Concat two one-word arrays: **1279**
- Concat two five-word arrays: **2498**

***

### substr(bytes32, uint8)

`function substr(bytes32 self, uint8 startIndex) internal pure returns (bytes32)`

Create a substring of a `bytes32`, starting at `startIndex`.

##### params

- `bytes32 self`: The source bytes32.
- `uint8 startIndex`: The start index.

##### requires

- `startIndex < 32`

##### returns

- `bytes32`: The substring.

##### ensures

- sst = self.substr(startIndex) => for i in [0, 32 - startIndex): sst[i] == self[startIndex + i], for i in [32 - startIndex, 32), sst[i] == 0.
##### gascosts

- Fixed: **226**

***

### substr(bytes32, uint8, uint8)

`function substr(bytes32 self, uint8 startIndex, uint8 len) internal pure returns (bytes32)`

Create a substring of a `bytes32`, starting at `startIndex`.

##### params

- `bytes32 self`: The source bytes32.
- `uint8 startIndex`: The start index.
- `uint8 len`: The number of bytes to copy.

##### requires

- `startIndex < 32`
- `startIndex + len <= 32`

##### returns

- `bytes32`: The substring.

##### ensures

- sst = self.substr(startIndex, len) => for i in [0, len): sst[i] == self[startIndex + i] && for i in [len, 32), sst[i] == 0.
##### gascosts

- Fixed: **383**

***

### toBytes(bytes32)

`function toBytes(bytes32 self) internal pure returns (bytes memory)`

Create a new `bytes memory` from a `bytes32`.

##### params

- `bytes32 self`: The source bytes32.


##### returns

- `bytes memory`: The bytes as a `bytes memory`. Note that the bytes array will be of length 32.

##### ensures

- `bts = self.toBytes() => bts.length = 32`.
- `bts = self.toBytes() => for i in [0, 32): bts[i] = self[i]`.
##### gascosts

- Fixed: **225**

***

### toBytes(bytes32, uint8)

`function toBytes(bytes32 self, uint8 len) internal pure returns (bytes memory)`

Create a new `bytes memory` by copying `len` bytes from the source `bytes32`.

##### params

- `bytes32 self`: The source bytes32.
- `uint8 len`: The source bytes32.


##### returns

- `bytes memory`: The bytes as a `bytes memory`. Note that the bytes array will be of length 32.

##### ensures

- `bts = self.toBytes(len) => bts.length = len`.
- `bts = self.toBytes(len) => for i in [0, len): bts[i] = self[i]`.
##### gascosts

- Fixed: **289**

***

### toBytes(address)

`function toBytes(address self) internal pure returns (bytes memory)`

Create a new `bytes memory` from an `address`. Note that bytes use big endian formatting, i.e. resultBytes[0] is the highest order byte.

##### params

- `address self`: The source address.


##### returns

- `bytes memory`: The address as a `bytes memory`. Note that the bytes array will be of length 20.

##### ensures

- `bts = self.toBytes() => bts.length = 20`.
- `bts = self.toBytes() => for i in [0, 20): bts[i] = bytes20(self)[i]`.
##### gascosts

- Fixed: **467**

***

### toBytes(uint)

`function toBytes(uint self) internal pure returns (bytes memory)`

Create a new `bytes memory` from a `uint`. Note that bytes use big endian formatting, i.e. resultBytes[0] is the highest order byte.

##### params

- `uint self`: The source uint.


##### returns

- `bytes memory`: The uint as a `bytes memory`. Note that the bytes array will be of length 32.

##### ensures

- `bts = self.toBytes() => bts.length = 32`.
- `bts = self.toBytes() => for i in [0, 32): bts[i] = bytes32(self)[i]`.
##### gascosts

- Fixed: **381**

***

### toBytes(uint, uint16)

`function toBytes(uint self, uint16 bitsize) internal pure returns (bytes memory)`

Create a new `bytes memory` from a `uint`. Only `bitsize` bits are copied. Note that bytes use big endian formatting, i.e. resultBytes[0] is the highest order byte.

##### params

- `uint self`: The source uint.
- `uint16 bitsize`: The number of bits to use.

##### requires

- `8 <= bitsize`
- `bitsize <= 256`
- `bitsize % 8 == 0`

##### returns

- `bytes memory`: The uint as a `bytes memory`. Note that the bytes array will be of length `bitsize / 8`.

##### ensures

- `bts = self.toBytes(bitsize) => bts.length = bitsize / 8`.
- `bts = self.toBytes(bitsize) => for i in [0, bitsize / 8): bts[i] = byte(self >> bitsize - 8 - i*8 & 0xFF)`.
##### gascosts

- Fixed: **684**

***

### toBytes(bool)

`function toBytes(bool self) internal pure returns (bytes memory)`

Create a new `bytes memory` from a `boolean`.

##### params

- `bool self`: The source boolean.


##### returns

- `bytes memory`: The boolean as a `bytes memory`. Note that the bytes array will be of length 1.

##### ensures

- `bts = self.toBytes() => bts.length = 1`.
- `bts = self.toBytes() => if self == true: bts = [1], else bts = [0].
##### gascosts

- Fixed: **225**

***

### highestByteSet(bytes32)

`function highestByteSet(bytes32 self) internal pure returns (uint8 highest)`

Calculates the index of the highest non-zero byte in a `bytes32`. Note that bytes uses big endian ordering (the most significant byte is the lowest).

##### params

- `bytes32 self`: The source bytes.

##### requires

- `self != 0`

##### returns

- `uint8 highest`: The index of the highest byte set.

##### ensures

- `highest = self.highestByteSet() => if i > highest: self[i] == 0`.
##### gascosts

- Highest byte set for max index: **321**
- Highest byte set for min index: **731**

***

### lowestByteSet(bytes32)

`function lowestByteSet(bytes32 self) internal pure returns (uint8 lowest)`

Calculates the index of the lowest non-zero byte in a `bytes32`. Note that bytes uses big endian ordering (the most significant byte is the lowest).

##### params

- `bytes32 self`: The source bytes.

##### requires

- `self != 0`

##### returns

- `uint8 lowest`: The index of the lowest byte set.

##### ensures

- `lowest = self.lowestByteSet() => if i < lowest: self[i] == 0`.
##### gascosts

- Lowest byte set for max index: **336**
- Lowest byte set for min index: **746**

***

### highestByteSet(uint)

`function highestByteSet(uint self) internal pure returns (uint8 highest)`

Calculates the index of the highest non-zero byte in a `uint`. Note that integers uses little endian ordering (the least significant byte is the lowest).

##### params

- `uint self`: The source uint.

##### requires

- `self != 0`

##### returns

- `uint8 highest`: The index of the highest byte set.

##### ensures

- `highest = self.highestByteSet() => if i > highest: self >> i*8 == 0`.
##### gascosts

- Highest byte set for max index: **677**
- Highest byte set for min index: **267**

***

### lowestByteSet(uint)

`function lowestByteSet(uint self) internal pure returns (uint8 lowest)`

Calculates the index of the lowest non-zero byte in a `uint`. Note that bytes uses little endian ordering (the most significant byte is the lowest).

##### params

- `uint self`: The source uint.

##### requires

- `self != 0`

##### returns

- `uint8 lowest`: The index of the lowest byte set.

##### ensures

- `lowest = self.lowestByteSet() => if i < lowest: self << (32 - lowest)*8 == 0`.
##### gascosts

- Lowest byte set for max index: **662**
- Lowest byte set for min index: **252**

