pragma solidity ^0.4.16;
pragma experimental "v0.5.0";
pragma experimental "ABIEncoderV2";


library Math {

    uint constant internal UINT_ZERO = 0;
    uint constant internal UINT_ONE = 1;
    uint constant internal UINT_TWO = 2;
    uint constant internal UINT_MAX = ~uint(0);
    uint constant internal UINT_MIN = 0;

    int constant internal INT_ZERO = 0;
    int constant internal INT_ONE = 1;
    int constant internal INT_TWO = 2;
    int constant internal INT_MINUS_ONE = -1;
    int constant internal INT_MAX = int(2**255 - 1);
    int constant internal INT_MIN = int(2**255);

    // For when a Uint needs to be passed by reference.
    struct Uint {
        uint n;
    }

    // For when an Int needs to be passed by reference.
    struct Int {
        uint n;
    }

    // Some math ops with overflow guards.
    function exactAdd(uint self, uint other) internal pure returns (uint sum) {
        sum = self + other;
        require(sum >= self);
    }

    function exactSub(uint self, uint other) internal pure returns (uint diff) {
        require(other <= self);
        diff = self - other;
    }

    function exactMul(uint self, uint other) internal pure returns (uint prod) {
        prod = self * other;
        require(self == 0 || prod / self == other);
    }

    function exactAdd(int self, int other) internal pure returns (int sum) {
        sum = self + other;
        if (self > 0 && other > 0) {
            require(0 <= sum && sum <= INT_MAX);
        } else if (self < 0 && other < 0) {
            require(INT_MIN <= sum && sum <= 0);
        }
    }

    function exactSub(int self, int other) internal pure returns (int diff) {
        diff = self - other;
        if (self > 0 && other < 0) {
            require(0 <= diff && diff <= INT_MAX);
        } else if (self < 0 && other > 0) {
            require(INT_MIN <= diff && diff <= 0);
        }
    }

    function exactMul(int self, int other) internal pure returns (int prod) {
        prod = self * other;
        require(self == 0 || ((other != INT_MIN || self != INT_MINUS_ONE) && prod / self == other));
    }

    function exactDiv(int self, int other) internal pure returns (int quot) {
        require(self != INT_MIN || other != INT_MINUS_ONE);
        quot = self / other;
    }
}