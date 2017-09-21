pragma solidity ^0.4.15;

contract STLTest {

    bool ret;

    function test() public {
        ret = true;
        testImpl();
    }

    function testImpl() internal;

}