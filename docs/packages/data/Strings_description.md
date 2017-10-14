This library can be used to validate that a solidity string is valid UTF-8.

Solidity strings uses the UTF-8 encoding, as defined in the unicode 10.0 standard: http://www.unicode.org/versions/Unicode10.0.0/, but the only checks that are currently carried out are compile-time checks of string literals. This library makes runtime checks possible.

The idea to add a UTF string validation library came from Arachnid's (Nick Johnson) string-utils: https://github.com/Arachnid/solidity-stringutils