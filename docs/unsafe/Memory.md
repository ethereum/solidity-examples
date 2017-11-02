# Memory



**Package:** unsafe

**Contract type:** Static library

**Source file:** [Memory.sol](../../src/unsafe/Memory.sol)


**Example usage:** [MemoryExamples.sol](../../examples/unsafe/MemoryExamples.sol)


**Tests source file:** [memory_tests.sol](../../test/unsafe/memory_tests.sol)


**Perf (gas usage) source file:** [memory_perfs.sol](../../perf/unsafe/memory_perfs.sol)


## description

The `unsafe` package contains code that performs potentially unsafe operations, for example reading and writing directly from memory. The memory library is used to work with memory directly; there are methods for copying memory, equals-checks, and converting from and to Solidity types.

In these docs, the word stored at memory address `n` is denoted `Memory[n]`. It is implicitly of type `uint`, but the regular index access syntax is used to point to individual bytes, e.g. byte number `m` of the word stored at address `n` is `Memory[n][m]`. Additionally, the free memory pointer is referred to `FMP`.

## Functions

- [equals(uint, uint, uint)](#equalsuint-uint-uint)
- [equals(uint, uint, bytes memory)](#equalsuint-uint-bytes-memory)
- [allocate(uint)](#allocateuint)
- [copy(uint, uint, uint)](#copyuint-uint-uint)
- [ptr(bytes)](#ptrbytes)
- [dataPtr(bytes)](#dataptrbytes)
- [fromBytes(bytes)](#frombytesbytes)
- [toBytes(uint, uint)](#tobytesuint-uint)
- [toUint(uint)](#touintuint)
- [toBytes32(uint)](#tobytes32uint)
- [toByte(uint, uint8)](#tobyteuint-uint8)

***

### equals(uint, uint, uint)

`function equals(uint addr, uint addr2, uint len) internal pure returns (bool)`

Checks if the data stored in two segments of memory is the same.

##### params

- `uint addr`: The first memory address.
- `uint addr2`: The second memory address.
- `uint len`: The number of bytes to check.


##### returns

- `bool`: `true` if the bytes are equal, otherwise false.

##### ensures

- `equals(addr1, addr2, len) => 'n' in [0, len), Memory[addr1 + n][0] == Memory[addr2 + n][0]`
##### gascosts

- Equals check of 16 bytes: **149**
- Equals check of one word: **149**
- Equals check of ten words: **278**
- Equals check of one hundred words: **1647**

***

### equals(uint, uint, bytes memory)

`function equals(uint addr, uint len, bytes memory bts) internal pure returns (bool)`

Checks if the data stored in a segment of memory is the same as (part of) the data stored by a `bytes memory`.

##### params

- `uint addr`: The memory address.
- `uint len`: The number of bytes to check.
- `bytes memory bts`: The bytes array.

##### requires

- len <= bts.length

##### returns

- `bool`: `true` if the bytes are equal, otherwise false.

##### ensures

- `equals(addr, len, bts) => 'n' in [0, len), Memory[addr + n][0] == uint8(bts[n])`
##### gascosts

- Equals check of one word: **256**

***

### allocate(uint)

`function allocate(uint numBytes) internal pure returns (uint addr)`

Allocates a section of memory, and initializes the bytes to `0`.

##### params

- `uint numBytes`: The number of bytes that should be allocated.


##### returns

- `uint addr`: The (starting) address of the newly allocated segment.

##### ensures

- `addr = allocate(len) => FMP += len && for 'n' in [0, len), Memory[addr + n] == 0`
##### gascosts

- Allocation of one word: **245**
- Allocation of ten words: **983**

***

### copy(uint, uint, uint)

`function copy(uint src, uint dest, uint len) internal pure`

Copy a segment of memory.

##### params

- `uint src`: The source address.
- `uint dest`: The destination address.
- `uint len`: The number of bytes to copy.



##### ensures

- `copy(src, dest, len) => for 'n' in [0, len), Memory[dest + n][0] == Memory[src + n][0]`
##### gascosts

- Copying 16 bytes: **210**
- Copying one word: **307**
- Copying ten words: **1153**

***

### ptr(bytes)

`function ptr(bytes bts) internal pure returns (uint addr)`

Get a memory pointer to a `bytes` array.

##### params

- `bytes bts`: The `bytes` array.


##### returns

- `uint addr`: The pointer to the `bytes` in memory.

##### gascosts

- Fixed: **55**

***

### dataPtr(bytes)

`function dataPtr(bytes bts) internal pure returns (uint addr)`

Get a memory pointer to the data section of a `bytes` array.

##### params

- `bytes bts`: The `bytes` array.


##### returns

- `uint addr`: The pointer to the data section of the `bytes` in memory.

##### gascosts

- Fixed: **61**

***

### fromBytes(bytes)

`function fromBytes(bytes bts) internal pure returns (uint addruint len)`

Get the address of the data stored by a `bytes memory`, and its length.

##### params

- `bytes bts`: The `bytes`.


##### returns

- `uint addr`: The pointer to the data section of the `bytes` in memory.
- `uint len`: The length of the `bytes`.

##### gascosts

- Fixed: **77**

***

### toBytes(uint, uint)

`function toBytes(uint addr, uint len) internal pure returns (bytes memory bts)`

Create a `bytes memory` from a starting address and a length. NOTE this will copy the bytes.

##### params

- `uint addr`: The memory address.
- `uint len`: The length.


##### returns

- `bytes memory bts`: The new `bytes` array.

##### gascosts

- Create a one word long byte array: **532**

***

### toUint(uint)

`function toUint(uint addr) internal pure returns (uint n)`

Get a word of memory as a `uint`

##### params

- `uint addr`: The memory address.


##### returns

- `uint n`: The word as a `uint`.

##### gascosts

- Fixed: **58**

***

### toBytes32(uint)

`function toBytes32(uint addr) internal pure returns (bytes32 bts)`

Get a word of memory as a `bytes32`

##### params

- `uint addr`: The memory address.


##### returns

- `bytes32 bts`: The word as a `bytes32`.

##### gascosts

- Fixed: **58**

***

### toByte(uint, uint8)

`function toByte(uint addr, uint8 index) internal pure returns (byte b)`

Get a single byte from memory.

##### params

- `uint addr`: The memory address.
- `uint8 index`: The index of the byte.

##### requires

- `0 <= index < 32`

##### returns

- `byte b`: The byte.

##### ensures

- `b = toByte(addr, index) => b == toBytes32(addr)[index]`
##### gascosts

- Fixed: **125**

