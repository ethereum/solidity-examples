pragma solidity ^0.4.16;
pragma experimental "v0.5.0";
pragma experimental "ABIEncoderV2";

import {Strings} from "../../src/strings/Strings.sol";

import {Memory} from "../../src/unsafe/Memory.sol";
import {STLTest} from "../STLTest.sol";

contract StringsTest is STLTest {
    using Strings for string;
    using Strings for bytes;
}

/************************ Parsing - success *************************/

// Size one

contract TestStringsParseRuneSizeOne is StringsTest {
    function testImpl() internal {
        bytes memory bts1 = hex"00";
        bytes memory bts2 = hex"7F";
        assert(bts1.parseRune(0) == 1);
        assert(bts2.parseRune(0) == 1);
    }
}


contract TestStringsParseRuneSizeOneSeveral is StringsTest {
    function testImpl() internal {
        bytes memory bts = hex"11007F22";
        assert(bts.parseRune(0) == 1);
        assert(bts.parseRune(1) == 1);
        assert(bts.parseRune(2) == 1);
        assert(bts.parseRune(3) == 1);
    }
}

// Size two

contract TestStringsParseRuneSizeTwo is StringsTest {
    function testImpl() internal {
        bytes memory bts1 = hex"C280";
        bytes memory bts2 = hex"C2BF";
        bytes memory bts3 = hex"DF80";
        bytes memory bts4 = hex"DFBF";
        assert(bts1.parseRune(0) == 2);
        assert(bts2.parseRune(0) == 2);
        assert(bts3.parseRune(0) == 2);
        assert(bts4.parseRune(0) == 2);
    }
}


contract TestStringsParseRuneSizeTwoSeveral is StringsTest {
    function testImpl() internal {
        bytes memory bts = hex"DF8045C2BF22DF80";
        assert(bts.parseRune(0) == 2);
        assert(bts.parseRune(2) == 1);
        assert(bts.parseRune(3) == 2);
        assert(bts.parseRune(5) == 1);
        assert(bts.parseRune(6) == 2);
    }
}

// Size three

contract TestStringsParseRuneSizeThreeE0 is StringsTest {
    function testImpl() internal {
        bytes memory bts1 = hex"E0A080";
        bytes memory bts2 = hex"E0A0BF";
        bytes memory bts3 = hex"E0BF80";
        bytes memory bts4 = hex"E0BFBF";
        assert(bts1.parseRune(0) == 3);
        assert(bts2.parseRune(0) == 3);
        assert(bts3.parseRune(0) == 3);
        assert(bts4.parseRune(0) == 3);
    }
}


contract TestStringsParseRuneSizeThreeE0Several is StringsTest {
    function testImpl() internal {
        bytes memory bts = hex"E0A08024E0A0BFC2BFE0BF80E0BFBF";
        assert(bts.parseRune(0) == 3);
        assert(bts.parseRune(3) == 1);
        assert(bts.parseRune(4) == 3);
        assert(bts.parseRune(7) == 2);
        assert(bts.parseRune(9) == 3);
        assert(bts.parseRune(12) == 3);
    }
}


contract TestStringsParseRuneSizeThreeE1toEC is StringsTest {
    function testImpl() internal {
        bytes memory bts1 = hex"E18080";
        bytes memory bts2 = hex"E180BF";
        bytes memory bts3 = hex"E1BF80";
        bytes memory bts4 = hex"E1BFBF";
        bytes memory bts5 = hex"EC8080";
        bytes memory bts6 = hex"EC80BF";
        bytes memory bts7 = hex"ECBF80";
        bytes memory bts8 = hex"ECBFBF";
        assert(bts1.parseRune(0) == 3);
        assert(bts2.parseRune(0) == 3);
        assert(bts3.parseRune(0) == 3);
        assert(bts4.parseRune(0) == 3);
        assert(bts5.parseRune(0) == 3);
        assert(bts6.parseRune(0) == 3);
        assert(bts7.parseRune(0) == 3);
        assert(bts8.parseRune(0) == 3);
    }
}


contract TestStringsParseRuneSizeThreeE1toECSeveral is StringsTest {
    function testImpl() internal {
        bytes memory bts = hex"E1BF80E4A088E9BF80EC9491";
        assert(bts.parseRune(0) == 3);
        assert(bts.parseRune(3) == 3);
        assert(bts.parseRune(6) == 3);
        assert(bts.parseRune(9) == 3);
    }
}


contract TestStringsParseRuneSizeThreeED is StringsTest {
    function testImpl() internal {
        bytes memory bts1 = hex"ED8080";
        bytes memory bts2 = hex"ED80BF";
        bytes memory bts3 = hex"ED9F80";
        bytes memory bts4 = hex"ED9FBF";
        assert(bts1.parseRune(0) == 3);
        assert(bts2.parseRune(0) == 3);
        assert(bts3.parseRune(0) == 3);
        assert(bts4.parseRune(0) == 3);
    }
}


contract TestStringsParseRuneSizeThreeEDSeveral is StringsTest {
    function testImpl() internal {
        bytes memory bts = hex"ED87A0ED90AFED9EBBED8A9A";
        assert(bts.parseRune(0) == 3);
        assert(bts.parseRune(3) == 3);
        assert(bts.parseRune(6) == 3);
        assert(bts.parseRune(9) == 3);
    }
}


contract TestStringsParseRuneSizeThreeEEtoEF is StringsTest {
    function testImpl() internal {
        bytes memory bts1 = hex"EE8080";
        bytes memory bts2 = hex"EE80BF";
        bytes memory bts3 = hex"EEBF80";
        bytes memory bts4 = hex"EEBFBF";
        bytes memory bts5 = hex"EF8080";
        bytes memory bts6 = hex"EF80BF";
        bytes memory bts7 = hex"EFBF80";
        bytes memory bts8 = hex"EFBFBF";
        assert(bts1.parseRune(0) == 3);
        assert(bts2.parseRune(0) == 3);
        assert(bts3.parseRune(0) == 3);
        assert(bts4.parseRune(0) == 3);
        assert(bts5.parseRune(0) == 3);
        assert(bts6.parseRune(0) == 3);
        assert(bts7.parseRune(0) == 3);
        assert(bts8.parseRune(0) == 3);
    }
}


contract TestStringsParseRuneSizeThreeEEtoEFSeveral is StringsTest {
    function testImpl() internal {
        bytes memory bts = hex"EEBF80EFA088EFBF80EE9491";
        assert(bts.parseRune(0) == 3);
        assert(bts.parseRune(3) == 3);
        assert(bts.parseRune(6) == 3);
        assert(bts.parseRune(9) == 3);
    }
}


contract TestStringsParseRuneSizeFourF0 is StringsTest {
    function testImpl() internal {
        bytes memory bts1 = hex"F0908080";
        bytes memory bts2 = hex"F09080BF";
        bytes memory bts3 = hex"F090BF80";
        bytes memory bts4 = hex"F090BFBF";
        bytes memory bts5 = hex"F0BF8080";
        bytes memory bts6 = hex"F0BF80BF";
        bytes memory bts7 = hex"F0BFBF80";
        bytes memory bts8 = hex"F0BFBFBF";
        assert(bts1.parseRune(0) == 4);
        assert(bts2.parseRune(0) == 4);
        assert(bts3.parseRune(0) == 4);
        assert(bts4.parseRune(0) == 4);
        assert(bts5.parseRune(0) == 4);
        assert(bts6.parseRune(0) == 4);
        assert(bts7.parseRune(0) == 4);
        assert(bts8.parseRune(0) == 4);
    }
}


contract TestStringsParseRuneSizeThreeF0Several is StringsTest {
    function testImpl() internal {
        bytes memory bts = hex"F09FA680F09FA780F09FA68BF09FA691";
        assert(bts.parseRune(0) == 4);
        assert(bts.parseRune(4) == 4);
        assert(bts.parseRune(8) == 4);
        assert(bts.parseRune(12) == 4);
    }
}


contract TestStringsParseRuneSizeFourF1 is StringsTest {
    function testImpl() internal {
        bytes memory bts1 = hex"F1808080";
        bytes memory bts2 = hex"F18080BF";
        bytes memory bts3 = hex"F180BF80";
        bytes memory bts4 = hex"F180BFBF";
        bytes memory bts5 = hex"F1BF8080";
        bytes memory bts6 = hex"F1BF80BF";
        bytes memory bts7 = hex"F1BFBF80";
        bytes memory bts8 = hex"F1BFBFBF";
        assert(bts1.parseRune(0) == 4);
        assert(bts2.parseRune(0) == 4);
        assert(bts3.parseRune(0) == 4);
        assert(bts4.parseRune(0) == 4);
        assert(bts5.parseRune(0) == 4);
        assert(bts6.parseRune(0) == 4);
        assert(bts7.parseRune(0) == 4);
        assert(bts8.parseRune(0) == 4);
    }
}


contract TestStringsParseRuneSizeFourF3 is StringsTest {
    function testImpl() internal {
        bytes memory bts1 = hex"F3808080";
        bytes memory bts2 = hex"F38080BF";
        bytes memory bts3 = hex"F380BF80";
        bytes memory bts4 = hex"F380BFBF";
        bytes memory bts5 = hex"F3BF8080";
        bytes memory bts6 = hex"F3BF80BF";
        bytes memory bts7 = hex"F3BFBF80";
        bytes memory bts8 = hex"F3BFBFBF";
        assert(bts1.parseRune(0) == 4);
        assert(bts2.parseRune(0) == 4);
        assert(bts3.parseRune(0) == 4);
        assert(bts4.parseRune(0) == 4);
        assert(bts5.parseRune(0) == 4);
        assert(bts6.parseRune(0) == 4);
        assert(bts7.parseRune(0) == 4);
        assert(bts8.parseRune(0) == 4);
    }
}


contract TestStringsParseRuneSizeThreeF1toF3Several is StringsTest {
    function testImpl() internal {
        bytes memory bts = hex"F3808080F2BF80BFF1BF8080F1BFBFBF";
        assert(bts.parseRune(0) == 4);
        assert(bts.parseRune(4) == 4);
        assert(bts.parseRune(8) == 4);
        assert(bts.parseRune(12) == 4);
    }
}


contract TestStringsParseRuneSizeFourF4 is StringsTest {
    function testImpl() internal {
        bytes memory bts1 = hex"F4808080";
        bytes memory bts2 = hex"F48080BF";
        bytes memory bts3 = hex"F4808F80";
        bytes memory bts4 = hex"F4808FBF";
        bytes memory bts5 = hex"F48F8080";
        bytes memory bts6 = hex"F48F80BF";
        bytes memory bts7 = hex"F48F8F80";
        bytes memory bts8 = hex"F48F8FBF";
        assert(bts1.parseRune(0) == 4);
        assert(bts2.parseRune(0) == 4);
        assert(bts3.parseRune(0) == 4);
        assert(bts4.parseRune(0) == 4);
        assert(bts5.parseRune(0) == 4);
        assert(bts6.parseRune(0) == 4);
        assert(bts7.parseRune(0) == 4);
        assert(bts8.parseRune(0) == 4);
    }
}


contract TestStringsParseRuneSizeThreeF4Several is StringsTest {
    function testImpl() internal {
        bytes memory bts = hex"F48080BFF4808F80F48F80BFF48F8FBF";
        assert(bts.parseRune(0) == 4);
        assert(bts.parseRune(4) == 4);
        assert(bts.parseRune(8) == 4);
        assert(bts.parseRune(12) == 4);
    }
}

/************************ Parsing - fails *************************/

// 1 byte characters

contract TestStringsParseRuneThrows1FBHigh is StringsTest {
    function testImpl() internal {
        bytes memory bts = hex"80";
        bts.parseRune(0);
    }
}

// 2 byte characters

contract TestStringsParseRuneThrows2FBLow is StringsTest {
    function testImpl() internal {
        bytes memory bts = hex"C180";
        bts.parseRune(0);
    }
}


contract TestStringsParseRuneThrows2SBLow is StringsTest {
    function testImpl() internal {
        bytes memory bts = hex"C479";
        bts.parseRune(0);
    }
}


contract TestStringsParseRuneThrows2FBHigh is StringsTest {
    function testImpl() internal {
        bytes memory bts = hex"C1C0";
        bts.parseRune(0);
    }
}

// 3 byte characters

contract TestStringsParseRuneThrows3E0SBLow is StringsTest {
    function testImpl() internal {
        bytes memory bts = hex"E09980";
        bts.parseRune(0);
    }
}


contract TestStringsParseRuneThrows3E0SBHigh is StringsTest {
    function testImpl() internal {
        bytes memory bts = hex"E0C080";
        bts.parseRune(0);
    }
}


contract TestStringsParseRuneThrows3E0TBLow is StringsTest {
    function testImpl() internal {
        bytes memory bts = hex"E0A17F";
        bts.parseRune(0);
    }
}


contract TestStringsParseRuneThrows3E0TBHigh is StringsTest {
    function testImpl() internal {
        bytes memory bts = hex"E0A1C0";
        bts.parseRune(0);
    }
}


contract TestStringsParseRuneThrows3E1toECSBLow is StringsTest {
    function testImpl() internal {
        bytes memory bts = hex"E37F80";
        bts.parseRune(0);
    }
}


contract TestStringsParseRuneThrows3E1toECSBHigh is StringsTest {
    function testImpl() internal {
        bytes memory bts = hex"E3C080";
        bts.parseRune(0);
    }
}


contract TestStringsParseRuneThrows3E1toECTBLow is StringsTest {
    function testImpl() internal {
        bytes memory bts = hex"E3BF7F";
        bts.parseRune(0);
    }
}


contract TestStringsParseRuneThrows3E1toECTBHigh is StringsTest {
    function testImpl() internal {
        bytes memory bts = hex"E3BFC0";
        bts.parseRune(0);
    }
}


contract TestStringsParseRuneThrows3EDSBLow is StringsTest {
    function testImpl() internal {
        bytes memory bts = hex"ED7F80";
        bts.parseRune(0);
    }
}


contract TestStringsParseRuneThrows3EDSBHigh is StringsTest {
    function testImpl() internal {
        bytes memory bts = hex"EDA080";
        bts.parseRune(0);
    }
}


contract TestStringsParseRuneThrows3EDTBLow is StringsTest {
    function testImpl() internal {
        bytes memory bts = hex"ED9F7F";
        bts.parseRune(0);
    }
}


contract TestStringsParseRuneThrows3EDTBHigh is StringsTest {
    function testImpl() internal {
        bytes memory bts = hex"ED9FC0";
        bts.parseRune(0);
    }
}


contract TestStringsParseRuneThrows3EEtoEFSBLow is StringsTest {
    function testImpl() internal {
        bytes memory bts = hex"EE7F80";
        bts.parseRune(0);
    }
}


contract TestStringsParseRuneThrows3EEtoEFSBHigh is StringsTest {
    function testImpl() internal {
        bytes memory bts = hex"EEC080";
        bts.parseRune(0);
    }
}


contract TestStringsParseRuneThrows3EEtoEFTBLow is StringsTest {
    function testImpl() internal {
        bytes memory bts = hex"EEBF7F";
        bts.parseRune(0);
    }
}


contract TestStringsParseRuneThrows3EEtoEFTBHigh is StringsTest {
    function testImpl() internal {
        bytes memory bts = hex"EEBFC0";
        bts.parseRune(0);
    }
}

// 4 byte characters

contract TestStringsParseRuneThrows4F0SBLow is StringsTest {
    function testImpl() internal {
        bytes memory bts = hex"F08F80BF";
        bts.parseRune(0);
    }
}


contract TestStringsParseRuneThrows4F0SBHigh is StringsTest {
    function testImpl() internal {
        bytes memory bts = hex"F0C080BF";
        bts.parseRune(0);
    }
}


contract TestStringsParseRuneThrows4F0TBLow is StringsTest {
    function testImpl() internal {
        bytes memory bts = hex"F0807FBF";
        bts.parseRune(0);
    }
}


contract TestStringsParseRuneThrows4F0TBHigh is StringsTest {
    function testImpl() internal {
        bytes memory bts = hex"F080C0BF";
        bts.parseRune(0);
    }
}


contract TestStringsParseRuneThrows4F0FBLow is StringsTest {
    function testImpl() internal {
        bytes memory bts = hex"F080BF7F";
        bts.parseRune(0);
    }
}


contract TestStringsParseRuneThrows4F0FBHigh is StringsTest {
    function testImpl() internal {
        bytes memory bts = hex"F080BFC0";
        bts.parseRune(0);
    }
}


contract TestStringsParseRuneThrows4F1toF3SBLow is StringsTest {
    function testImpl() internal {
        bytes memory bts = hex"F27F80BF";
        bts.parseRune(0);
    }
}


contract TestStringsParseRuneThrows4F1toF3SBHigh is StringsTest {
    function testImpl() internal {
        bytes memory bts = hex"F2C080BF";
        bts.parseRune(0);
    }
}


contract TestStringsParseRuneThrows4F1toF3TBLow is StringsTest {
    function testImpl() internal {
        bytes memory bts = hex"F2807FBF";
        bts.parseRune(0);
    }
}


contract TestStringsParseRuneThrows4F1toF3TBHigh is StringsTest {
    function testImpl() internal {
        bytes memory bts = hex"F280C0BF";
        bts.parseRune(0);
    }
}


contract TestStringsParseRuneThrows4F1toF3FBLow is StringsTest {
    function testImpl() internal {
        bytes memory bts = hex"F280BF7F";
        bts.parseRune(0);
    }
}


contract TestStringsParseRuneThrows4F1toF3FBHigh is StringsTest {
    function testImpl() internal {
        bytes memory bts = hex"F280BFC0";
        bts.parseRune(0);
    }
}


contract TestStringsParseRuneThrows4F4SBLow is StringsTest {
    function testImpl() internal {
        bytes memory bts = hex"F47F80BF";
        bts.parseRune(0);
    }
}


contract TestStringsParseRuneThrows4F4SBHigh is StringsTest {
    function testImpl() internal {
        bytes memory bts = hex"F49080BF";
        bts.parseRune(0);
    }
}


contract TestStringsParseRuneThrows4F4TBLow is StringsTest {
    function testImpl() internal {
        bytes memory bts = hex"F4807FBF";
        bts.parseRune(0);
    }
}


contract TestStringsParseRuneThrows4F4TBHigh is StringsTest {
    function testImpl() internal {
        bytes memory bts = hex"F480C0BF";
        bts.parseRune(0);
    }
}


contract TestStringsParseRuneThrows4F4FBLow is StringsTest {
    function testImpl() internal {
        bytes memory bts = hex"F480BF7F";
        bts.parseRune(0);
    }
}


contract TestStringsParseRuneThrows4F4FBHigh is StringsTest {
    function testImpl() internal {
        bytes memory bts = hex"F480BFC0";
        bts.parseRune(0);
    }
}

/************************* Validate ***************************/

contract TestStringsValidateNull is StringsTest {
    function testImpl() internal {
        string memory str = "";
        str.validate();
    }
}


contract TestStringsValidateRunePoem is StringsTest {
    function testImpl() internal {
        string memory str = "ᚠᛇᚻ᛫ᛒᛦᚦ᛫ᚠᚱᚩᚠᚢᚱ᛫ᚠᛁᚱᚪ᛫ᚷᛖᚻᚹᛦᛚᚳᚢᛗ ᛋᚳᛖᚪᛚ᛫ᚦᛖᚪᚻ᛫ᛗᚪᚾᚾᚪ᛫ᚷᛖᚻᚹᛦᛚᚳ᛫ᛗᛁᚳᛚᚢᚾ᛫ᚻᛦᛏ᛫ᛞᚫᛚᚪᚾ ᚷᛁᚠ᛫ᚻᛖ᛫ᚹᛁᛚᛖ᛫ᚠᚩᚱ᛫ᛞᚱᛁᚻᛏᚾᛖ᛫ᛞᚩᛗᛖᛋ᛫ᚻᛚᛇᛏᚪᚾ";
        str.validate();
    }
}


contract TestStringsValidateBrut is StringsTest {
    function testImpl() internal {
        string memory str = "An preost wes on leoden, Laȝamon was ihoten He wes Leovenaðes sone -- liðe him be Drihten. He wonede at Ernleȝe at æðelen are chirechen, Uppen Sevarne staþe, sel þar him þuhte, Onfest Radestone, þer he bock radde.";
        str.validate();
    }
}


contract TestStringsValidateOdysseusElytis is StringsTest {
    function testImpl() internal {
        string memory str = "Τη γλώσσα μου έδωσαν ελληνική το σπίτι φτωχικό στις αμμουδιές του Ομήρου. Μονάχη έγνοια η γλώσσα μου στις αμμουδιές του Ομήρου. από το Άξιον Εστί του Οδυσσέα Ελύτη";
        str.validate();
    }
}


contract TestStringsValidatePushkinsHorseman is StringsTest {
    function testImpl() internal {
        string memory str = "На берегу пустынных волн Стоял он, дум великих полн, И вдаль глядел. Пред ним широко Река неслася; бедный чёлн По ней стремился одиноко. По мшистым, топким берегам Чернели избы здесь и там, Приют убогого чухонца; И лес, неведомый лучам В тумане спрятанного солнца, Кругом шумел.";
        str.validate();
    }
}


contract TestStringsValidateKnightInTigerSkin is StringsTest {
    function testImpl() internal {
        string memory str = "ვეპხის ტყაოსანი შოთა რუსთაველი ღმერთსი შემვედრე, ნუთუ კვლა დამხსნას სოფლისა შრომასა, ცეცხლს, წყალსა და მიწასა, ჰაერთა თანა მრომასა; მომცნეს ფრთენი და აღვფრინდე, მივჰხვდე მას ჩემსა ნდომასა, დღისით და ღამით ვჰხედვიდე მზისა ელვათა კრთომაასა.";
        str.validate();
    }
}


contract TestStringsValidateQuickBrownFoxHebrew is StringsTest {
    function testImpl() internal {
        string memory str = ".זה כיף סתם לשמוע איך תנצח קרפד עץ טוב בגן";
        str.validate();
    }
}


contract TestStringsValidateQuickBrownFoxHiragana is StringsTest {
    function testImpl() internal {
        string memory str = "いろはにほへど　ちりぬるを わがよたれぞ　つねならむ うゐのおくやま　けふこえて あさきゆめみじ　ゑひもせず";
        str.validate();
    }
}