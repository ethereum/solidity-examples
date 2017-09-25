import {Memory} from "../unsafe/Memory.sol";


// String validation library.
//
// Strings uses the UTF-8 encoding, as defined in the unicode 10.0 standard:
// http://www.unicode.org/versions/Unicode10.0.0/
//
// Idea taken from Arachnid's (Nick Johnson) string-utils:
// https://github.com/Arachnid/solidity-stringutils
library Strings {

    // Key bytes.
    // http://www.unicode.org/versions/Unicode10.0.0/UnicodeStandard-10.0.pdf
    // Table 3-7, p 126, Well-Formed UTF-8 Byte Sequences

    // Default 80..BF range
    byte constant DL = 0x80;
    byte constant DH = 0xBF;

    // Row - number of bytes

    // R1 - 1
    byte constant B11L = 0x00;
    byte constant B11H = 0x7F;

    // R2 - 2
    byte constant B21L = 0xC2;
    byte constant B21H = 0xDF;

    // R3 - 3
    byte constant B31 = 0xE0;
    byte constant B32L = 0xA0;
    byte constant B32H = 0xBF;

    // R4 - 3
    byte constant B41L = 0xE1;
    byte constant B41H = 0xEC;

    // R5 - 3
    byte constant B51 = 0xED;
    byte constant B52L = 0x80;
    byte constant B52H = 0x9F;

    // R6 - 3
    byte constant B61L = 0xEE;
    byte constant B61H = 0xEF;

    // R7 - 4
    byte constant B71 = 0xF0;
    byte constant B72L = 0x90;
    byte constant B72H = 0xBF;

    // R8 - 4
    byte constant B81L = 0xF1;
    byte constant B81H = 0xF3;

    // R9 - 4
    byte constant B91 = 0xF4;
    byte constant B92L = 0x80;
    byte constant B92H = 0x8F;

    // Check that a string is well-formed.
    function validate(string memory self) internal pure {
        var bts = bytes(self);
        if (bts.length == 0) {
            return;
        }
        uint bytePos = 0;
        while (bytePos < bts.length) {
            bytePos += parseRune(bts, bytePos);
        }
        require(bytePos == bts.length);
    }

    // Parses the (presumed) UTF-8 encoded character that starts at the given byte, and
    // returns its length. Fails if the encoding is not valid. Hefty function, although
    // runes normally doesn't go beyond two bytes in size (or even one).
    function parseRune(bytes memory bts, uint bytePos) internal pure returns (uint len) {
        byte b = bts[bytePos];
        if (b <= B11H) {
            len = 1;
        } else if (B21L <= b && b <= B21H) {
            var bp1 = bts[bytePos + 1];
            require(DL <= bp1 && bp1 <= DH);
            len = 2;
        } else if (b == B31) {
            validateWithNextDefault(bts, bytePos + 1, B32L, B32H);
            len = 3;
        } else if (b == B51) {
            validateWithNextDefault(bts, bytePos + 1, B52L, B52H);
            len = 3;
        } else if ((B41L <= b && b <= B41H) || b == B61L || b == B61H) {
            validateWithNextDefault(bts, bytePos + 1, DL, DH);
            len = 3;
        } else if (b == B71) {
            validateWithNextTwoDefault(bts, bytePos + 1, B72L, B72H);
            len = 4;
        } else if (B81L <= b && b <= B81H) {
            validateWithNextTwoDefault(bts, bytePos + 1, DL, DH);
            len = 4;
        } else if (b == B91) {
            validateWithNextTwoDefault(bts, bytePos + 1, B92L, B92H);
            len = 4;
        } else {
            require(false);
        }
    }

    function validateWithNextDefault(bytes memory bts, uint bytePos, byte low, byte high) private pure {
        byte b = bts[bytePos];
        require(low <= b && b <= high);
        b = bts[bytePos + 1];
        require(DL <= b && b <= DH);
    }

    function validateWithNextTwoDefault(bytes memory bts, uint bytePos, byte low, byte high) private pure {
        byte b = bts[bytePos];
        require(low <= b && b <= high);
        b = bts[bytePos + 1];
        require(DL <= b && b <= DH);
        b = bts[bytePos + 2];
        require(DL <= b && b <= DH);
    }

}