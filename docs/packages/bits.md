## Bits

This library contains functions for working with bits.

### Bits.sol

#### setBit

`setBit(uint self, uint8 index) internal constant returns (uint)`

Sets the bit at `index` to `1`.

#### clearBit

`clearBit(uint self, uint8 index) internal constant returns (uint)`

Sets the bit at `index` to `0`.

#### toggleBit

`toggleBit(uint self, uint8 index) internal constant returns (uint)`

Toggles the bit at `index` to `1`. Equivalent to:

´bit(self, index) == 0 ? setBit(self, index) : clearBit(self, index);`

#### bit

`bit(uint self, uint8 index) internal constant returns (uint8)`

Returns the bit at `index`.

#### bitSet

`bitSet(uint self, uint8 index) internal constant returns (bool)`

Returns `true` if the bit at `index` is `1`, otherwise `false`. Equivalent to:

`bit(self, index) == 1;`

#### bitEqual

`bitEqual(uint self, uint other, uint8 index) internal constant returns (bool)`

Returns `true` if the bit at `index` in `self` is the same as the corresponding bit in `other`. Equivalent to:

`bit(self, index) == bit(other, index);`

#### bitAnd

`bitAnd(uint self, uint other, uint8 index) internal constant returns (uint8)`

Returns the bit at `index` of `self` ANDed with the corresponding bit in `other`. Equivalent to:

`bit(self, index) & bit(other, index);`

#### bitOr

`bitOr(uint self, uint other, uint8 index)`

Returns the bit at `index` of `self` ORed with the corresponding bit in `other`. Equivalent to:

`bit(self, index) | bit(other, index);`

#### bitXor

`bitXor(uint self, uint other, uint8 index) internal constant returns (uint8)`

Returns the bit at `index` of `self` XORed with the corresponding bit in `other`. Equivalent to:

`bit(self, index) ^ bit(other, index);`

#### bits

`bits(uint self, uint8 startIndex, uint8 numBits) internal constant returns (uint)`

Returns a string of bits from `self`, starting at `startIndex`, and ending at `startIndex + numBits`. The bits are returned in the form of a `uint`.

`throw`s if `startIndex + numBits > 256`

#### highestBitSet

`highestBitSet(uint self) internal constant returns (uint8 highest)`

Returns the index of the highest bit set in `self`.

`throw`s if `self == 0`

#### lowestBitSet

`lowestBitSet(uint self) internal constant returns (uint8 lowest)`

Returns the index of the lowest bit set in `self`.

`throw`s if `self == 0`