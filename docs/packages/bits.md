# bits

The ´bits´ package contains internal functions for working with bits.

## Bits.sol

Type: **Internal library**

`Bits` is the main library of this package.

### Functions

#### setBit

`setBit(uint self, uint8 index) internal constant returns (uint)`

##### description

Sets the bit at position `index` to `1`.

##### arguments

`uint self` - The bitfield.

`uint8 index` - The index of the bit.

##### returns

A new `uint` with the operation applied to it.

##### ensures

`self.setBit(index) >> index & 1 == 1`

#### clearBit

`clearBit(uint self, uint8 index) internal constant returns (uint)`

##### description

Sets the bit at position `index` to `0`.

##### arguments

`uint self` - The bitfield.

`uint8 index` - The index of the bit.

##### returns

A new `uint` with the operation applied to it.

##### ensures

`self.setBit(index) >> index & 1 == 0`

#### toggleBit

`toggleBit(uint self, uint8 index) internal constant returns (uint)`

##### description

Toggles the bit at position `index`. Equivalent to:

`bit(self, index) == 0 ? setBit(self, index) : clearBit(self, index);`

##### arguments

`uint self` - The bitfield.

`uint8 index` - The index of the bit.

##### returns

A new `uint` with the operation applied to it.

##### ensures

`self >> index & 1 != self.setBit(index) >> index & 1`

#### bit

`bit(uint self, uint8 index) internal constant returns (uint8)`

##### description

Returns the bit at `index`.

##### arguments

`uint self` - The bitfield.

`uint8 index` - The index of the bit.

##### returns

The value of the bit at `index` (`0` or `1`)

#### bitSet

`bitSet(uint self, uint8 index) internal constant returns (bool)`

##### description

Check if the bit at `index` is set.

##### arguments

`uint self` - The bitfield.

`uint8 index` - The index of the bit.

##### returns

`true` if the value of the bit at `index` is `1`, otherwise `false`.

#### bitEqual

`bitEqual(uint self, uint other, uint8 index) internal constant returns (bool)`

##### description

Checks if the bit at `index` in `self` is the same as the corresponding bit in `other`. Equivalent to:

`bit(self, index) == bit(other, index);`

##### arguments

`uint self` - The first bitfield.

`uint other` - The second bitfield.

`uint8 index` - The index of the bit.

##### returns

`true` if the value of the bits at `index` is the same for both bitfields, otherwise `false`.

#### bitAnd

`bitAnd(uint self, uint other, uint8 index) internal constant returns (uint8)`

##### description

Calculates the bitwise `AND` of the bit at position `index` in `self` and the corresponding bit in `other`. Equivalent to:

`bit(self, index) & bit(other, index);`

##### arguments

`uint self` - The first bitfield.

`uint other` - The second bitfield.

`uint8 index` - The index of the bit.

##### returns

The bitwise `AND` of the bit at position `index` in `self` and the corresponding bit in `other` (`0` or `1`).

#### bitOr

`bitOr(uint self, uint other, uint8 index)`

##### description

Calculates the bitwise `OR` of the bit at position `index` in `self` and the corresponding bit in `other`. Equivalent to:

`bit(self, index) | bit(other, index);`

##### arguments

`uint self` - The first bitfield.

`uint other` - The second bitfield.

`uint8 index` - The index of the bit.

##### returns

The bitwise `OR` of the bit at position `index` in `self` and the corresponding bit in `other` (`0` or `1`).

#### bitXor

`bitXor(uint self, uint other, uint8 index) internal constant returns (uint8)`

##### description

Calculates the bitwise `XOR` of the bit at position `index` in `self` and the corresponding bit in `other`. Equivalent to:

`bit(self, index) ^ bit(other, index);`

##### arguments

`uint self` - The first bitfield.

`uint other` - The second bitfield.

`uint8 index` - The index of the bit.

##### returns

The bitwise `XOR` of the bit at position `index` in `self` and the corresponding bit in `other` (`0` or `1`).

#### bits

`bits(uint self, uint8 startIndex, uint8 numBits) internal constant returns (uint)`

##### description

Extracts `numBits` bits from `self`, starting at `startIndex`.

To get all the bits, you would do: `self.bits(0, 256)`

##### arguments

`uint self` - The bitfield.

`uint8 startIndex` - The second bitfield.

`uint8 numBits` - The index of the bit.

##### requires

`numBits > 0`

`startIndex + numBits <= 256`

##### returns

The bits from `startIndex` to `startIndex + numBits` (inclusive) as a `uint`.

#### highestBitSet

`highestBitSet(uint self) internal constant returns (uint8 highest)`

##### description

Calculates the index of the highest bit set in `self`.

##### arguments

`uint self` - The bitfield.

##### requires

`self != 0`

##### returns

The index of the highest bit set in `self` as a `uint8`.

#### lowestBitSet

`lowestBitSet(uint self) internal constant returns (uint8 lowest)`

##### description

Calculates the index of the lowest bit set in `self`.

##### arguments

`uint self` - The bitfield.

##### requires

`self != 0`

##### returns

The index of the lowest bit set in `self` as a `uint8`.