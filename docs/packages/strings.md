## Strings

String validation library. This library can be used to validate that a
solidity string is valid UTF-8.

Solidity strings uses the UTF-8 encoding, as defined in the unicode 10.0 standard: http://www.unicode.org/versions/Unicode10.0.0/

The idea to add a UTF string validation library came from Arachnid's (Nick Johnson) string-utils: https://github.com/Arachnid/solidity-stringutils


    // Find the lowest byte set of a uint. This function counts from the least
    // significant byte.
    // highestByteSet(0x01) = 0;
    // highestByteSet(0xbb00aa00) = 3; (bb)