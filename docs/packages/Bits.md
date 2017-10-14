# Bits



**Package:** bits

**Contract type:** Static library

**Source file:** [Bits.sol](../../src/bits/Bits.sol)

**Example usage:** [BitsExamples.sol](../../examples/bits/BitsExamples.sol)

**Tests source file:** [bits_tests.sol](../../test/bits/bits_tests.sol)

**Perf (gas usage) source file:** [bits_perfs.sol](../../perf/bits/bits_perfs.sol)


## description

The `Bits` library is used for working with the individual bits of a `uint`.

## Functions

- [setBit(uint, uint8)](#setbituint-uint8)
- [clearBit(uint, uint8)](#clearbituint-uint8)
- [toggleBit(uint, uint8)](#togglebituint-uint8)
- [bit(uint, uint8)](#bituint-uint8)
- [bitSet(uint, uint8)](#bitsetuint-uint8)
- [bitEqual(uint, uint, uint8)](#bitequaluint-uint-uint8)
- [bitAnd(uint, uint, uint8)](#bitanduint-uint-uint8)
- [bitOr(uint, uint, uint8)](#bitoruint-uint-uint8)
- [bitXor(uint, uint, uint8)](#bitxoruint-uint-uint8)
- [bits(uint, uint8, uint16)](#bitsuint-uint8-uint16)
- [highestBitSet(uint)](#highestbitsetuint)
- [lowestBitSet(uint)](#lowestbitsetuint)

***

### setBit(uint, uint8)

`function setBit(uint, uint8) internal pure returns (uint)`

Sets the bit at position `index` to `1`.

##### params

- `uint self`: The bitfield.
- `uint8 index`: The index of the bit.


##### returns

- `uint`: A new `uint` with the operation applied to it.

##### ensures

- `self.setBit(index) >> index & 1 == 1`
##### gascosts

- Fixed: **161**

***

### clearBit(uint, uint8)

`function clearBit(uint, uint8) internal pure returns (uint)`

Sets the bit at position `index` to `0`.

##### params

- `uint self`: The bitfield.
- `uint8 index`: The index of the bit.


##### returns

- `uint`: A new `uint` with the operation applied to it.

##### ensures

- `self.setBit(index) >> index & 1 == 0`
##### gascosts

- Fixed: **164**

***

### toggleBit(uint, uint8)

`function toggleBit(uint, uint8) internal pure returns (uint)`

Toggles the bit at position `index`.

##### params

- `uint self`: The bitfield.
- `uint8 index`: The index of the bit.


##### returns

- `uint`: A new `uint` with the operation applied to it.

##### ensures

- `newField = self.toggleBit(index) => newField.bit(index) == 1 - self.bit(index)`
##### gascosts

- Fixed: **161**

***

### bit(uint, uint8)

`function bit(uint, uint8) internal pure returns (uint8)`

Returns the bit at `index`.

##### params

- `uint self`: The bitfield.
- `uint8 index`: The index of the bit.


##### returns

- `uint8`: The value of the bit at `index` (`0` or `1`).

##### gascosts

- Fixed: **164**

***

### bitSet(uint, uint8)

`function bitSet(uint, uint8) internal pure returns (bool)`

Check if the bit at `index` is set.

##### params

- `uint self`: The bitfield.
- `uint8 index`: The index of the bit.


##### returns

- `bool`: `true` if the value of the bit at `index` is `1`, otherwise `false`.

##### gascosts

- Fixed: **170**

***

### bitEqual(uint, uint, uint8)

`function bitEqual(uint, uint, uint8) internal pure returns (bool)`

Checks if the bit at `index` in `self` is the same as the corresponding bit in `other`.

##### params

- `uint self`: The first bitfield.
- `uint other`: The second bitfield.
- `uint8 index`: The index of the bit.


##### returns

- `bool`: `true` if the value of the bits at `index` is the same for both bitfields, otherwise `false`.

##### gascosts

- Fixed: **184**

***

### bitAnd(uint, uint, uint8)

`function bitAnd(uint, uint, uint8) internal pure returns (uint8)`

Calculates the bitwise `AND` of the bit at position `index` in `self` and the corresponding bit in `other`.

##### params

- `uint self`: The first bitfield.
- `uint other`: The second bitfield.
- `uint8 index`: The index of the bit.


##### returns

- `uint8`: The bitwise `AND` of the bit at position `index` in `self` and the corresponding bit in `other` (`0` or `1`).

##### gascosts

- Fixed: **178**

***

### bitOr(uint, uint, uint8)

`function bitOr(uint, uint, uint8) internal pure returns (uint8)`

Calculates the bitwise `OR` of the bit at position `index` in `self` and the corresponding bit in `other`.

##### params

- `uint self`: The first bitfield.
- `uint other`: The second bitfield.
- `uint8 index`: The index of the bit.


##### returns

- `uint8`: The bitwise `OR` of the bit at position `index` in `self` and the corresponding bit in `other` (`0` or `1`).

##### gascosts

- Fixed: **178**

***

### bitXor(uint, uint, uint8)

`function bitXor(uint, uint, uint8) internal pure returns (uint8)`

Calculates the bitwise `XOR` of the bit at position `index` in `self` and the corresponding bit in `other`.

##### params

- `uint self`: The first bitfield.
- `uint other`: The second bitfield.
- `uint8 index`: The index of the bit.


##### returns

- `uint8`: The bitwise `XOR` of the bit at position `index` in `self` and the corresponding bit in `other` (`0` or `1`).

##### gascosts

- Fixed: **178**

***

### bits(uint, uint8, uint16)

`function bits(uint, uint8, uint16) internal pure returns (uint)`

Extracts `numBits` bits from `self`, starting at `startIndex`.

To get all the bits: `self.bits(0, 256)`

##### params

- `uint self`: The first bitfield.
- `uint8 startIndex`: The index of the starting bit.
- `uint16 numBits`: The number of bits.

##### requires

- `0 < numBits`
- `startIndex < 256`
- `startIndex + numBits <= 256`

##### returns

- `uint`: The bits from `startIndex` to `startIndex + numBits` (inclusive) as a `uint`.

##### gascosts

- Fixed: **385**

***

### highestBitSet(uint)

`function highestBitSet(uint) internal pure returns (uint8)`

Calculates the index of the highest bit set in `self`.

##### params

- `uint self`: The bitfield.

##### requires

- `self != 0`

##### returns

- `uint8`: The index of the highest bit set in `self` as a `uint8`.

##### gascosts

- For highest bit set == 0: **2845**
- For highest bit set == 31: **3759**

***

### lowestBitSet(uint)

`function lowestBitSet(uint) internal pure returns (uint8)`

Calculates the index of the lowest bit set in `self`.

##### params

- `uint self`: The bitfield.

##### requires

- `self != 0`

##### returns

- `uint8`: The index of the lowest bit set in `self` as a `uint8`.

##### gascosts

- For lowest bit set == 0: **2181**
- For lowest bit set == 31: **3095**

