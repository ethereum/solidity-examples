# bytes

The ´bytes´ package contains internal functions for working with `bytes`.

## Bytes.sol

Type: **Internal library**

`Bytes` is the main library of this package.

### Functions

#### equals

`function equals(bytes memory self, bytes memory other) internal pure returns (bool equal)`

Checks if two `bytes memory` are equal. The two `bytes memory` are equal if:

1. `self.length == other.length`
2. For each index `i` in `[0, self.length)`: `self[i] == other[i]`

Returns `true` if the two `bytes memory` are equal, otherwise false.

This is a more efficient method then checking each index manually.

#### equalsRef

`function equalsRef(bytes memory self, bytes memory other) internal pure returns (bool equal)`

Checks if two `bytes memory` are the same by comparing their internal references.

Returns `true` if the two `bytes memory` references the same address in memory, otherwise false.

If `bts.equalsRef(bts2)`, then either of them can be used to mutate the other; in fact, `equalsRef` was added specifically for doing those kind of checks.

If `bts.equalsRef(bts2)`, then it is implied that `bts.equals(bts2)`.

#### copy

`function copy(bytes memory self) internal pure returns (bytes memory);`

Creates a new, independent copy of a `bytes memory` array.

Returns the new copy, `bytes memory selfCopy`.

The copy satisfies the following:

1. `selfCopy.equals(self)`
1. `!selfCopy.equalsRef(self)`

The copy function has two additional version.

##### startIndex

`function copy(bytes memory self, uint startIdx) internal pure returns (bytes memory);`

Same as `copy` but starts copying at position `startIdx`.

Requires that: `startIndex < self.length`.

Ensures that: `selfCopy.length = self.length - startIndex`.

The copy will contain: `self[startIdx], self[startIdx + 1], ... , self[self.length - 1]`.

Calling `bts.copy()` is the same as calling `bts.copy(0)`.

##### startIndex and length

`function copy(bytes memory self, uint startIdx, uint len) internal pure returns (bytes memory);`

This function copies `len` number of bytes from `self`, starting at `startIndex`.

Requires that: `startIndex < self.length` and `startIdx + len <= self.length`.

The copy, `selfCopy`, will have:

```
selfCopy[0] = self[startIdx]
selfCopy[1] = self[startIdx + 1]
...
selfCopy[len - 1] = self[startIdx + len - 1]
```

Calling `bts.copy()` is the same as calling `bts.copy(0, bts.length)`.

Y
X
ADD

ADD ADD ADD X  ADD Z  Y  ADD Y  Z  Q
rt  N0  N2  L1 N4  L5 L6 N7  L8 L9 L10

01
02

(ADD (ADD (ADD L3 (ADD L0 L1)) (ADD L8 L9) ) L10 )

(ADD (ADD (ADD PUSH V3 (ADD PUSH V0 PUSH V1)) (ADD PUSH V8 PUSH V9) ) PUSH V10 )


ADD ADD ADD PUSH V3 ADD PUSH V0 PUSH V1 ADD PUSH V8 PUSH V9 PUSH V10

PUSH V10 PUSH V9 PUSH V8 ADD PUSH V1 PUSH V0 ADD PUSH V3 ADD ADD ADD



#### concat

`function concat(bytes memory self, bytes memory other) internal pure returns (bytes memory)`

Concatenates two `bytes memory` arrays into one single array.

Returns the concatenated bytes `bytes memory btsCnct`.

This function works with 0-length bytes as well.

The concatenated bytes will have `btsCnct.length = self.length + other.length`, and the general form will be:

```
btsCnct[0] = self[0]
btsCnct[1] = self[1]
...
btsCnct[self.length - 1] = self[self.length - 1]
btsCnct[self.length] = other[0]
btsCnct[self.length + 1] = other[1]
...
btsCnct[self.length + other.length - 1] = other[other.length - 1]
```

