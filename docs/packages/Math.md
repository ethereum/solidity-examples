# Math



**Package:** math

**Contract type:** Static library

**Source file:** [Math.sol](../../src/math/Math.sol)

**Example usage:** [MathExamples.sol](../../examples/math/MathExamples.sol)

**Tests source file:** [math_tests.sol](../../test/math/math_tests.sol)

**Perf (gas usage) source file:** [math_perfs.sol](../../perf/math/math_perfs.sol)


## description

The Math library contains functions for performing mathematical operations on number types, such as exact arithmetic.

Notice that there is no function for exact unsigned integer division, as division by zero is handled automatically by the compiler.

Inspiration for adding this library was taken from the SafeMath library in zeppelin-solidity: https://github.com/OpenZeppelin/zeppelin-solidity/blob/353285e5d96477b4abb86f7cde9187e84ed251ac/contracts/math/SafeMath.sol

## Functions

- [exactAdd(uint, uint)](#exactadduint-uint)
- [exactSub(uint, uint)](#exactsubuint-uint)
- [exactMul(uint, uint)](#exactmuluint-uint)
- [exactAdd(int, int)](#exactaddint-int)
- [exactSub(int, int)](#exactsubint-int)
- [exactMul(int, int)](#exactmulint-int)
- [exactDiv(int, int)](#exactdivint-int)

***

### exactAdd(uint, uint)

`function exactAdd(uint, uint) internal pure returns (uint sum)`

Adds two unsigned integers. Throws if the result is not inside the allowed range.

##### params

- `uint self`: The first number.
- `uint other`: The second number.

##### requires

- `sum >= self`

##### returns

- `uint sum`: The sum.

##### gascosts

- Fixed: **98**

***

### exactSub(uint, uint)

`function exactSub(uint, uint) internal pure returns (uint diff)`

Subtracts `other` from `self`. Throws if the result is not inside the allowed range.

##### params

- `uint self`: The first number.
- `uint other`: The second number.

##### requires

- `other <= self`

##### returns

- `uint diff`: The difference.

##### gascosts

- Fixed: **98**

***

### exactMul(uint, uint)

`function exactMul(uint, uint) internal pure returns (uint prod)`

Multiplies two numbers. Throws if the result is not inside the allowed range.

##### params

- `uint self`: The first number.
- `uint other`: The second number.

##### requires

- `self == 0 || prod / self == other`

##### returns

- `uint prod`: The product.

##### gascosts

- Fixed: **156**

***

### exactAdd(int, int)

`function exactAdd(int, int) internal pure returns (int sum)`

Adds two signed integers. Throws if the result is not inside the allowed range.

##### params

- `int self`: The first number.
- `int other`: The second number.

##### requires

- `if (self > 0 && other > 0): 0 <= sum && sum <= INT_MAX`
- `if (self < 0 && other < 0): INT_MIN <= sum && sum <= 0`

##### returns

- `int sum`: The sum.

##### gascosts

- Fixed: **200**

***

### exactSub(int, int)

`function exactSub(int, int) internal pure returns (int diff)`

Subtracts `other` from `self`. Throws if the result is not inside the allowed range.

##### params

- `int self`: The first number.
- `int other`: The second number.

##### requires

- `if (self > 0 && other < 0): 0 <= diff && diff <= INT_MAX`
- `if (self < 0 && other > 0): INT_MIN <= diff && diff <= 0`

##### returns

- `int diff`: The difference.

##### gascosts

- Fixed: **256**

***

### exactMul(int, int)

`function exactMul(int, int) internal pure returns (int mul)`

Multiplies two numbers. Throws if the result is not inside the allowed range.

##### params

- `int self`: The first number.
- `int other`: The second number.

##### requires

- `self == 0 || ((other != INT_MIN || self != INT_MINUS_ONE) && prod / self == other)`

##### returns

- `int mul`: The product.

##### gascosts

- Fixed: **256**

***

### exactDiv(int, int)

`function exactDiv(int, int) internal pure returns (int quot)`

Divides `self` with `other`. Throws if the result is not inside the allowed range.

##### params

- `int self`: The first number.
- `int other`: The second number.

##### requires

- `self != INT_MIN || other != INT_MINUS_ONE`

##### returns

- `int quot`: The quota.

##### gascosts

- Fixed: **140**

