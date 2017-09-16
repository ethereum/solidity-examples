pragma solidity ^0.4.15;

contract STLPerf {

    function perf() constant returns (uint) {
        uint gasPre = msg.gas;
        perfImpl();
        uint gasPost = msg.gas;
        return gasPost - gasPre;
    }

    function perfImpl() internal;

}