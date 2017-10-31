pragma solidity ^0.4.16;
pragma experimental "v0.5.0";
pragma experimental "ABIEncoderV2";


contract STLTest {

    function test() public payable returns (bool ret) {
        ret = true;
        testImpl();
    }

    function testImpl() internal;

}