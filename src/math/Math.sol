/*


 */
/*
 * title: Math
 * author: Andreas Olofsson (androlo@tutanota.de)
 *
 * description:
 *
 * Various different math operations.
 *
 * Inspiration is taken from the SafeMath library in zeppelin-solidity:
 * https://github.com/OpenZeppelin/zeppelin-solidity/blob/353285e5d96477b4abb86f7cde9187e84ed251ac/contracts/math/SafeMath.sol
 */
library Math {

    uint constant UINT_ZERO = 0;
    uint constant UINT_ONE = 1;
    uint constant UINT_TWO = 2;
    uint constant UINT_MAX = ~uint(0);
    uint constant UINT_MIN = 0;

    int constant INT_ZERO = 0;
    int constant INT_ONE = 1;
    int constant INT_TWO = 2;
    int constant INT_MINUS_ONE = -1;
    int constant INT_MAX = int(2**255 - 1);
    int constant INT_MIN = int(-(2**255));

    // For when a Uint needs to be passed by reference.
    struct Uint {
        uint n;
    }

    // For when an Int needs to be passed by reference.
    struct Int {
        uint n;
    }

    // Some math ops with overflow guards.

    function exactAdd(uint a, uint b) internal pure returns (uint sum) {
        sum = a + b;
        require(sum >= a);
    }

    function exactSub(uint a, uint b) internal pure returns (uint diff) {
        require(b <= a);
        diff = a - b;
    }

    function exactMul(uint a, uint b) internal pure returns (uint prod) {
        prod = a * b;
        require(a == 0 || prod / a == b);
    }

    function exactAdd(int a, int b) internal pure returns (int sum) {
        sum = a + b;
        if (a > 0 && b > 0) {
            require(0 <= sum && sum <= INT_MAX);
        } else if (a < 0 && b < 0) {
            require(INT_MIN <= sum && sum <= 0);
        }
    }

    function exactSub(int a, int b) internal pure returns (int diff) {
        require(b != INT_MIN);
        return exactAdd(a, -b);
    }

    function exactMul(int a, int b) internal pure returns (int prod) {
        prod = a * b;
        require((a != INT_MIN || b != INT_MINUS_ONE) && (b != INT_MIN || a != INT_MINUS_ONE));
        require(a == 0 || prod / a == b);
    }

    function exactDiv(int a, int b) internal pure returns (int quot) {
        require(a != INT_MIN || b != INT_MINUS_ONE);
        quot = a / b;
    }
}