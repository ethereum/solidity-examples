## Overflow rules

This document specifies which operations may cause over/underflows, and which does not.

#### Unsigned Integers

|  Operator  | Overflow | Underflow | Comment |
|------------|----------|-----------|---------|
| +          | x        | -         |         |
| ++         | x        | -         |         |
| +=         | x        | -         |         |
| + (unary)  | N/A      | N/A       | deprecated |
| -          | -        | x         |         |
| --         | -        | x         |         |
| -=         | -        | x         |         |
| - (unary)  | -        | x         |         |
| *          | x        | -         |         |
| *=         | x        | -         |         |
| **         | x        | -         | multiplication |
| /          | -        | -         |         |
| /=         | -        | -         |         |
| %          | -        | -         |         |
| %=         | -        | -         |         |
| <<         | -        | -         |         |
| <<=        | -        | -         |         |
| >>         | -        | -         |         |
| >>=        | -        | -         |         |
| &          | -        | -         |         |
| &=         | -        | -         |         |
| \|         | -        | -         |         |
| \|=        | -        | -         |         |
| ^          | -        | -         |         |
| ^=         | -        | -         |         |
| ~          | -        | -         |         |
| ~=         | -        | -         |         |

#### Signed Integers

|  Operator  | Overflow | Underflow | Comment |
|------------|----------|-----------|---------|
| +          | x        | x         |         |
| ++         | x        | x         |         |
| +=         | x        | x         |         |
| + (unary)  | N/A      | N/A       | deprecated |
| -          | x        | x         |         |
| --         | x        | x         |         |
| -=         | x        | x         |         |
| - (unary)  | x        | x         |         |
| *          | x        | x         | `INT256_MIN == -INT256_MIN` |
| *=         | x        | x         | `INT256_MIN == -INT256_MIN` |
| **         | x        | x         | multiplication |
| /          | -        | -         | `INT256_MIN == -INT256_MIN` |
| /=         | -        | -         | `INT256_MIN == -INT256_MIN` |
| %          | -        | -         |         |
| %=         | -        | -         |         |
| <<         | -        | -         | multiplication |
| <<=        | -        | -         | multiplication |
| >>         | -        | -         | division |
| >>=        | -        | -         | division |
| &          | -        | -         |         |
| &=         | -        | -         |         |
| \|         | -        | -         |         |
| \|=        | -        | -         |         |
| ^          | -        | -         |         |
| ^=         | -        | -         |         |
| ~          | -        | -         |         |
| ~=         | -        | -         |         |