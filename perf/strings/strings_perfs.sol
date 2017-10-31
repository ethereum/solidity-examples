pragma solidity ^0.4.16;
pragma experimental "v0.5.0";
pragma experimental "ABIEncoderV2";

import {Strings} from "../../src/strings/Strings.sol";
import {STLPerf} from "../STLPerf.sol";
import {Memory} from "../../src/unsafe/Memory.sol";

/* solhint-disable max-line-length */

contract StringsPerf is STLPerf {
    using Strings for string;
    using Strings for uint;
}


contract PerfStringsParseRuneLengthOne is StringsPerf {

    function perf() public payable returns (uint) {
        bytes memory bts = hex"00";
        uint addr = Memory.dataPtr(bts);
        uint gasPre = msg.gas;
        addr.parseRune();
        uint gasPost = msg.gas;
        return gasPre - gasPost;
    }
}


contract PerfStringsParseRuneLengthTwo is StringsPerf {

    function perf() public payable returns (uint) {
        bytes memory bts = hex"DF80";
        uint addr = Memory.dataPtr(bts);
        uint gasPre = msg.gas;
        addr.parseRune();
        uint gasPost = msg.gas;
        return gasPre - gasPost;
    }
}


contract PerfStringsParseRuneLengthThree is StringsPerf {

    function perf() public payable returns (uint) {
        bytes memory bts = hex"E0A080";
        uint addr = Memory.dataPtr(bts);
        uint gasPre = msg.gas;
        addr.parseRune();
        uint gasPost = msg.gas;
        return gasPre - gasPost;
    }
}


contract PerfStringsParseRuneLengthFour is StringsPerf {

    function perf() public payable returns (uint) {
        bytes memory bts = hex"F0908080";
        uint addr = Memory.dataPtr(bts);
        uint gasPre = msg.gas;
        addr.parseRune();
        uint gasPost = msg.gas;
        return gasPre - gasPost;
    }
}


contract PerfStringsParseValidateQuickBrownFox is StringsPerf {

    function perf() public payable returns (uint) {
        string memory str = "The quick brown fox jumps over the lazy dog";
        uint gasPre = msg.gas;
        str.validate();
        uint gasPost = msg.gas;
        return gasPre - gasPost;
    }
}


contract PerfStringsParseValidateRunePoem is StringsPerf {

    function perf() public payable returns (uint) {
        string memory str = "ᚠᛇᚻ᛫ᛒᛦᚦ᛫ᚠᚱᚩᚠᚢᚱ᛫ᚠᛁᚱᚪ᛫ᚷᛖᚻᚹᛦᛚᚳᚢᛗ ᛋᚳᛖᚪᛚ᛫ᚦᛖᚪᚻ᛫ᛗᚪᚾᚾᚪ᛫ᚷᛖᚻᚹᛦᛚᚳ᛫ᛗᛁᚳᛚᚢᚾ᛫ᚻᛦᛏ᛫ᛞᚫᛚᚪᚾ ᚷᛁᚠ᛫ᚻᛖ᛫ᚹᛁᛚᛖ᛫ᚠᚩᚱ᛫ᛞᚱᛁᚻᛏᚾᛖ᛫ᛞᚩᛗᛖᛋ᛫ᚻᛚᛇᛏᚪᚾ";
        uint gasPre = msg.gas;
        str.validate();
        uint gasPost = msg.gas;
        return gasPre - gasPost;
    }
}


contract PerfStringsParseValidateBrut is StringsPerf {

    function perf() public payable returns (uint) {
        string memory str = "An preost wes on leoden, Laȝamon was ihoten He wes Leovenaðes sone -- liðe him be Drihten. He wonede at Ernleȝe at æðelen are chirechen, Uppen Sevarne staþe, sel þar him þuhte, Onfest Radestone, þer he bock radde.";
        uint gasPre = msg.gas;
        str.validate();
        uint gasPost = msg.gas;
        return gasPre - gasPost;
    }
}
/* solhint-enable max-line-length */