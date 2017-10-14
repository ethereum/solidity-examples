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
