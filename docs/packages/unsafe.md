## Unsafe

The `unsafe` package contains code that performs potentially unsafe operations, for example reading and writing directly from memory. Additionally, unsafe code may be skipped by the analysis done done by the compiler.

### Memory.sol

The memory library is used to manipulate memory directly.

##### Array

The data-type used to represent an allocated segment of memory is `Memory.Array`:

```
struct Array {
    uint _len;
    uint _ptr;
}
```

`_ptr` is the memory address.

`_len` is the number of bytes, starting at the address.

You can use the functions in the `Memory` library to create `Array` objects in several different ways:

1. By calling the `allocate` method.

2. By copying an already existing `Array`, which will automatically allocate new memory for the copy.

3. By passing certain types of variables into their respective `from` method (`fromBytes`, `fromString`, `fromUint`).

Instantiating `Array`s Yourself is considered unsafe; they should be produced from the functions in the library since that will ensure that the memory they point to has been properly allocated.

A memory array can be nullified either by calling the (`destroy`) function, or by using `delete` (recommended), which will set both of its field to 0. Note that deleting a memory array does not free up the memory it points to, but in Ethereum contracts there is no point in doing that; the only reason for nullifying a `Array` is to signal that it has expired. Methods in this package does null checks before using any memory arrays.

There are a number of functions in the `Memory` library that starts with `unsafe`, meaning they are unsafe even for an unsafe package. One example is `unsafeCopy` which copies to memory without checking that the destination has been properly allocated. Internally, those functions are only called from other functions, after the required checks has been made, but the functions are exposed for those who do wish to do the checks themselves.