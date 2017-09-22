pragma solidity ^0.4.16;
pragma experimental "v0.5.0";
pragma experimental ABIEncoderV2;

contract STLTest {

    bool ret;

    function test() public payable {
        ret = true;
        testImpl();
    }

    function testImpl() internal;

}