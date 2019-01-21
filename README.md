# Standard library (draft) [![CircleCI](https://circleci.com/gh/ethereum/solidity-examples.svg?style=svg)](https://circleci.com/gh/ethereum/solidity-examples)

Temporary storage for a standard library of Solidity contracts.

The code in this library will only run in metropolis compliant networks, and it will only compile using Solidity version `0.5.0` and later.

## TOC

- [Purpose](#purpose)
- [Packages](#packages)
  - [bits](#bits)
  - [bytes](#bytes)
  - [math](#math)
  - [patricia_tree](#patricia_tree)
  - [strings](#strings)
  - [token](#token)
  - [unsafe](#unsafe)
- [Quality Assurance](#quality-assurance)
- [Commandline tool](#commandline-tool)
- [Q&A](qa)

## Purpose

The standard library should provide Solidity libraries / functions for performing common tasks, such as working with strings, bits, and other common types, and for working with Ethereum and Ethereum related technologies, like for example Patricia Tries.

## Packages

These are the different packages.

### bits

The `bits` package is used to work with bitfields (uints).

#### contracts

- [Bits](./docs/bits/Bits.md)

### bytes

The `bytes` package is used to work with `bytes` in memory, and to convert between `bytes` and other types.

#### contracts

- [Bytes](./docs/bytes/Bytes.md)

### math

The `math` package is used to do math with signed and unsigned integers.

#### contracts

- [ExactMath](./docs/math/ExactMath.md)

### patricia_tree

The `patricia_tree` package is used to work with the standard Solidity Patricia tree implementation by @chriseth.

#### contracts

- [PatriciaTree](./docs/patricia_tree/PatriciaTree.md)
- [Data](./docs/patricia_tree/Data.md)

### strings

The `strings` package is used to work Solidity `string`s. It only supports UTF-8 validation.

#### contracts

- [Strings](./docs/strings/Strings.md)

### tokens

The `tokens` package is used to work with Token contracts.

#### contracts

- [ERC20TokenFace](./docs/tokens/ERC20TokenFace.md)

### unsafe

The `unsafe` package is used to do unsafe operations, like working with memory directly.

#### contracts

- [Memory](./docs/unsafe/Memory.md)

## Quality Assurance

The standard library has well-documented routines for making sure that code meets the required standards when it comes to:

1. Security
2. Performance
3. Style
4. Documentation

Additionally, the tools used to guarantee this should be simple and easy to replace when new and better alternatives are made available.

### Testing

`npm test` - runs the contract test-suite, as well as the tests for the typescript code.

`npm run ts-test` - runs the typescript tests.

`npm run contracts-test` - runs the contract test-suite.

The contract tests requires `solc` and `evm` ([go ethereum](https://github.com/ethereum/go-ethereum)) to be installed and added to the $PATH. Test code is written in Solidity, and is executed directly in the evm.

For more information about the tests, such as the test file format, read the full [test documentation](./docs/testing.md).

For running tests with the command-line tool, check the [CLI documentation](./docs/cli.md).

### Performance

`npm run contracts-perf` will run the entire perf suite.

For more information about perf read the full [perf documentation](./docs/perf.md).

For running perf with the command-line tool, check the [CLI documentation](./docs/cli.md).

### Style

`npm run ts-lint` - will run TS-lint on the entire library.

`npm run contracts-lint` - will run [solhint](https://github.com/protofire/solhint) on all contracts.

The standard library should serve as an (or perhaps *the*) example of strict, idiomatic Solidity. This means all code should follow the style guide and the practices and patterns laid out at https://solidity.readthedocs.org.

### Documentation

Briefly: the documentation should specify - in a very clear and concise a way - what the contract of the library/function is, the interfaces / function signatures should reflect that, and the functions should (obviously) behave as described.

### Manual review

Code should be reviewed by at least one person other then the writer. There should also be review of tests, perf, docs, and code examples as well.

This should be done using the PR system in github.

### Issues and feedback

Github issues and gitter solidity channel.

### Ranking / categorization of contracts

The QA only really applies to code that is meant to be used in production, but the library will also include code that has not reached that level.

Node.js has a system of categorizing libraries, experimental, stable, deprecated, and so forth. This library should have something similar.

## Commandline tool

The library has a commandline tool which can be used to run tests, view documentation, and other things. The full docs can be found in the [commandline tool documentation](./docs/cli.md).