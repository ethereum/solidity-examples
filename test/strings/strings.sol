pragma solidity ^0.4.16;
pragma experimental "v0.5.0";
pragma experimental "ABIEncoderV2";

import {Strings} from "../../src/strings/Strings.sol";
import {Memory} from "../../src/unsafe/Memory.sol";
import {STLTest} from "../STLTest.sol";


contract StringsTest is STLTest {
    using Strings for string;
    using Strings for uint;
}

/* solhint-disable max-line-length */
/************************ Parsing - success *************************/
// Size one

contract TestStringsParseRuneSizeOne is StringsTest {
    function testImpl() internal {
        bytes memory bts1 = hex"00";
        bytes memory bts2 = hex"7F";
        var addr1 = Memory.dataPtr(bts1);
        var addr2 = Memory.dataPtr(bts2);
        assert(addr1.parseRune() == 1);
        assert(addr2.parseRune() == 1);
    }
}


contract TestStringsParseRuneSizeOneSeveral is StringsTest {
    function testImpl() internal {
        bytes memory bts = hex"11007F22";
        var addr1 = Memory.dataPtr(bts);
        var addr2 = Memory.dataPtr(bts) + 1;
        var addr3 = Memory.dataPtr(bts) + 2;
        var addr4 = Memory.dataPtr(bts) + 3;
        assert(addr1.parseRune() == 1);
        assert(addr2.parseRune() == 1);
        assert(addr3.parseRune() == 1);
        assert(addr4.parseRune() == 1);
    }
}

// Size two

contract TestStringsParseRuneSizeTwo is StringsTest {
    function testImpl() internal {
        bytes memory bts1 = hex"C280";
        bytes memory bts2 = hex"C2BF";
        bytes memory bts3 = hex"DF80";
        bytes memory bts4 = hex"DFBF";
        var addr1 = Memory.dataPtr(bts1);
        var addr2 = Memory.dataPtr(bts2);
        var addr3 = Memory.dataPtr(bts3);
        var addr4 = Memory.dataPtr(bts4);
        assert(addr1.parseRune() == 2);
        assert(addr2.parseRune() == 2);
        assert(addr3.parseRune() == 2);
        assert(addr4.parseRune() == 2);
    }
}


contract TestStringsParseRuneSizeTwoSeveral is StringsTest {
    function testImpl() internal {
        bytes memory bts = hex"DF8045C2BF22";
        var addr = Memory.dataPtr(bts);
        assert(addr.parseRune() == 2);
        assert((addr + 2).parseRune() == 1);
        assert((addr + 3).parseRune() == 2);
        assert((addr + 5).parseRune() == 1);
    }
}

// Size three

contract TestStringsParseRuneSizeThreeE0 is StringsTest {
    function testImpl() internal {
        bytes memory bts1 = hex"E0A080";
        bytes memory bts2 = hex"E0A0BF";
        bytes memory bts3 = hex"E0BF80";
        bytes memory bts4 = hex"E0BFBF";
        var addr1 = Memory.dataPtr(bts1);
        var addr2 = Memory.dataPtr(bts2);
        var addr3 = Memory.dataPtr(bts3);
        var addr4 = Memory.dataPtr(bts4);
        assert(addr1.parseRune() == 3);
        assert(addr2.parseRune() == 3);
        assert(addr3.parseRune() == 3);
        assert(addr4.parseRune() == 3);
    }
}


contract TestStringsParseRuneSizeThreeE0Several is StringsTest {
    function testImpl() internal {
        bytes memory bts = hex"E0A08024E0A0BFC2BFE0BF80E0BFBF";
        var addr = Memory.dataPtr(bts);
        assert(addr.parseRune() == 3);
        assert((addr + 3).parseRune() == 1);
        assert((addr + 4).parseRune() == 3);
        assert((addr + 7).parseRune() == 2);
        assert((addr + 9).parseRune() == 3);
        assert((addr + 12).parseRune() == 3);

    }
}


contract TestStringsParseRuneSizeThreeE1toEC is StringsTest {
    function testImpl() internal {
        bytes memory bts = hex"E18080";
        assert(Memory.dataPtr(bts).parseRune() == 3);

        bts = hex"E180BF";
        assert(Memory.dataPtr(bts).parseRune() == 3);

        bts = hex"E1BF80";
        assert(Memory.dataPtr(bts).parseRune() == 3);

        bts = hex"E1BFBF";
        assert(Memory.dataPtr(bts).parseRune() == 3);

        bts = hex"EC8080";
        assert(Memory.dataPtr(bts).parseRune() == 3);

        bts = hex"EC80BF";
        assert(Memory.dataPtr(bts).parseRune() == 3);

        bts = hex"ECBF80";
        assert(Memory.dataPtr(bts).parseRune() == 3);

        bts = hex"ECBFBF";
        assert(Memory.dataPtr(bts).parseRune() == 3);
    }
}


contract TestStringsParseRuneSizeThreeE1toECSeveral is StringsTest {
    function testImpl() internal {
        bytes memory bts = hex"E1BF80E4A088E9BF80EC9491";
        var addr = Memory.dataPtr(bts);
        assert(addr.parseRune() == 3);
        assert((addr + 3).parseRune() == 3);
        assert((addr + 6).parseRune() == 3);
        assert((addr + 9).parseRune() == 3);
    }
}


contract TestStringsParseRuneSizeThreeED is StringsTest {
    function testImpl() internal {
        bytes memory bts1 = hex"ED8080";
        bytes memory bts2 = hex"ED80BF";
        bytes memory bts3 = hex"ED9F80";
        bytes memory bts4 = hex"ED9FBF";
        var addr1 = Memory.dataPtr(bts1);
        var addr2 = Memory.dataPtr(bts2);
        var addr3 = Memory.dataPtr(bts3);
        var addr4 = Memory.dataPtr(bts4);
        assert(addr1.parseRune() == 3);
        assert(addr2.parseRune() == 3);
        assert(addr3.parseRune() == 3);
        assert(addr4.parseRune() == 3);
    }
}


contract TestStringsParseRuneSizeThreeEDSeveral is StringsTest {
    function testImpl() internal {
        bytes memory bts = hex"ED87A0ED90AFED9EBBED8A9A";
        var addr = Memory.dataPtr(bts);
        assert(addr.parseRune() == 3);
        assert((addr + 3).parseRune() == 3);
        assert((addr + 6).parseRune() == 3);
        assert((addr + 9).parseRune() == 3);
    }
}


contract TestStringsParseRuneSizeThreeEEtoEF is StringsTest {
    function testImpl() internal {

        bytes memory bts = hex"EE8080";
        assert(Memory.dataPtr(bts).parseRune() == 3);

        bts = hex"EE80BF";
        assert(Memory.dataPtr(bts).parseRune() == 3);

        bts = hex"EEBF80";
        assert(Memory.dataPtr(bts).parseRune() == 3);

        bts = hex"EEBFBF";
        assert(Memory.dataPtr(bts).parseRune() == 3);

        bts = hex"EF8080";
        assert(Memory.dataPtr(bts).parseRune() == 3);

        bts = hex"EF80BF";
        assert(Memory.dataPtr(bts).parseRune() == 3);

        bts = hex"EFBF80";
        assert(Memory.dataPtr(bts).parseRune() == 3);

        bts = hex"EFBFBF";
        assert(Memory.dataPtr(bts).parseRune() == 3);
    }
}


contract TestStringsParseRuneSizeThreeEEtoEFSeveral is StringsTest {
    function testImpl() internal {
        bytes memory bts = hex"EEBF80EFA088EFBF80EE9491";
        var addr = Memory.dataPtr(bts);
        assert(addr.parseRune() == 3);
        assert((addr + 3).parseRune() == 3);
        assert((addr + 6).parseRune() == 3);
        assert((addr + 9).parseRune() == 3);
    }
}


contract TestStringsParseRuneSizeFourF0 is StringsTest {
    function testImpl() internal {
        bytes memory bts = hex"F0908080";
        assert(Memory.dataPtr(bts).parseRune() == 4);

        bts = hex"F09080BF";
        assert(Memory.dataPtr(bts).parseRune() == 4);

        bts = hex"F090BF80";
        assert(Memory.dataPtr(bts).parseRune() == 4);

        bts = hex"F090BFBF";
        assert(Memory.dataPtr(bts).parseRune() == 4);

        bts = hex"F0BF8080";
        assert(Memory.dataPtr(bts).parseRune() == 4);

        bts = hex"F0BF80BF";
        assert(Memory.dataPtr(bts).parseRune() == 4);

        bts = hex"F0BFBF80";
        assert(Memory.dataPtr(bts).parseRune() == 4);

        bts = hex"F0BFBFBF";
        assert(Memory.dataPtr(bts).parseRune() == 4);
    }
}


contract TestStringsParseRuneSizeThreeF0Several is StringsTest {
    function testImpl() internal {
        bytes memory bts = hex"F09FA680F09FA780F09FA68BF09FA691";
        var addr = Memory.dataPtr(bts);
        assert(addr.parseRune() == 4);
        assert((addr + 4).parseRune() == 4);
        assert((addr + 8).parseRune() == 4);
        assert((addr + 12).parseRune() == 4);
    }
}


contract TestStringsParseRuneSizeFourF1 is StringsTest {
    function testImpl() internal {
        bytes memory bts = hex"F1808080";
        assert(Memory.dataPtr(bts).parseRune() == 4);

        bts = hex"F18080BF";
        assert(Memory.dataPtr(bts).parseRune() == 4);

        bts = hex"F180BF80";
        assert(Memory.dataPtr(bts).parseRune() == 4);

        bts = hex"F180BFBF";
        assert(Memory.dataPtr(bts).parseRune() == 4);

        bts = hex"F1BF8080";
        assert(Memory.dataPtr(bts).parseRune() == 4);

        bts = hex"F1BF80BF";
        assert(Memory.dataPtr(bts).parseRune() == 4);

        bts = hex"F1BFBF80";
        assert(Memory.dataPtr(bts).parseRune() == 4);

        bts = hex"F1BFBFBF";
        assert(Memory.dataPtr(bts).parseRune() == 4);
    }
}


contract TestStringsParseRuneSizeFourF3 is StringsTest {
    function testImpl() internal {
        bytes memory bts = hex"F3808080";
        assert(Memory.dataPtr(bts).parseRune() == 4);

        bts = hex"F38080BF";
        assert(Memory.dataPtr(bts).parseRune() == 4);

        bts = hex"F380BF80";
        assert(Memory.dataPtr(bts).parseRune() == 4);

        bts = hex"F380BFBF";
        assert(Memory.dataPtr(bts).parseRune() == 4);

        bts = hex"F3BF8080";
        assert(Memory.dataPtr(bts).parseRune() == 4);

        bts = hex"F3BF80BF";
        assert(Memory.dataPtr(bts).parseRune() == 4);

        bts = hex"F3BFBF80";
        assert(Memory.dataPtr(bts).parseRune() == 4);

        bts = hex"F3BFBFBF";
        assert(Memory.dataPtr(bts).parseRune() == 4);
    }
}


contract TestStringsParseRuneSizeThreeF1toF3Several is StringsTest {
    function testImpl() internal {
        bytes memory bts = hex"F3808080F2BF80BFF1BF8080F1BFBFBF";
        var addr = Memory.dataPtr(bts);
        assert(addr.parseRune() == 4);
        assert((addr + 4).parseRune() == 4);
        assert((addr + 8).parseRune() == 4);
        assert((addr + 12).parseRune() == 4);
    }
}


contract TestStringsParseRuneSizeFourF4 is StringsTest {
    function testImpl() internal {

        bytes memory bts = hex"F4808080";
        assert(Memory.dataPtr(bts).parseRune() == 4);

        bts = hex"F48080BF";
        assert(Memory.dataPtr(bts).parseRune() == 4);

        bts = hex"F4808F80";
        assert(Memory.dataPtr(bts).parseRune() == 4);

        bts = hex"F4808FBF";
        assert(Memory.dataPtr(bts).parseRune() == 4);

        bts = hex"F48F8080";
        assert(Memory.dataPtr(bts).parseRune() == 4);

        bts = hex"F48F80BF";
        assert(Memory.dataPtr(bts).parseRune() == 4);

        bts = hex"F48F8F80";
        assert(Memory.dataPtr(bts).parseRune() == 4);

        bts = hex"F48F8FBF";
        assert(Memory.dataPtr(bts).parseRune() == 4);
    }
}


contract TestStringsParseRuneSizeThreeF4Several is StringsTest {
    function testImpl() internal {
        bytes memory bts = hex"F48080BFF4808F80F48F80BFF48F8FBF";
        var addr = Memory.dataPtr(bts);
        assert(addr.parseRune() == 4);
        assert((addr + 4).parseRune() == 4);
        assert((addr + 8).parseRune() == 4);
        assert((addr + 12).parseRune() == 4);
    }
}

/************************ Parsing - fails *************************/
// 1 byte characters

contract TestStringsParseRuneThrows1FBHigh is StringsTest {
    function testImpl() internal {
        bytes memory bts = hex"80";
        Memory.dataPtr(bts).parseRune();
    }
}

// 2 byte characters

contract TestStringsParseRuneThrows2FBLow is StringsTest {
    function testImpl() internal {
        bytes memory bts = hex"C180";
        Memory.dataPtr(bts).parseRune();
    }
}


contract TestStringsParseRuneThrows2SBLow is StringsTest {
    function testImpl() internal {
        bytes memory bts = hex"C479";
        Memory.dataPtr(bts).parseRune();
    }
}


contract TestStringsParseRuneThrows2FBHigh is StringsTest {
    function testImpl() internal {
        bytes memory bts = hex"C1C0";
        Memory.dataPtr(bts).parseRune();
    }
}

// 3 byte characters

contract TestStringsParseRuneThrows3E0SBLow is StringsTest {
    function testImpl() internal {
        bytes memory bts = hex"E09980";
        Memory.dataPtr(bts).parseRune();
    }
}


contract TestStringsParseRuneThrows3E0SBHigh is StringsTest {
    function testImpl() internal {
        bytes memory bts = hex"E0C080";
        Memory.dataPtr(bts).parseRune();
    }
}


contract TestStringsParseRuneThrows3E0TBLow is StringsTest {
    function testImpl() internal {
        bytes memory bts = hex"E0A17F";
        Memory.dataPtr(bts).parseRune();
    }
}


contract TestStringsParseRuneThrows3E0TBHigh is StringsTest {
    function testImpl() internal {
        bytes memory bts = hex"E0A1C0";
        Memory.dataPtr(bts).parseRune();
    }
}


contract TestStringsParseRuneThrows3E1toECSBLow is StringsTest {
    function testImpl() internal {
        bytes memory bts = hex"E37F80";
        Memory.dataPtr(bts).parseRune();
    }
}


contract TestStringsParseRuneThrows3E1toECSBHigh is StringsTest {
    function testImpl() internal {
        bytes memory bts = hex"E3C080";
        Memory.dataPtr(bts).parseRune();
    }
}


contract TestStringsParseRuneThrows3E1toECTBLow is StringsTest {
    function testImpl() internal {
        bytes memory bts = hex"E3BF7F";
        Memory.dataPtr(bts).parseRune();
    }
}


contract TestStringsParseRuneThrows3E1toECTBHigh is StringsTest {
    function testImpl() internal {
        bytes memory bts = hex"E3BFC0";
        Memory.dataPtr(bts).parseRune();
    }
}


contract TestStringsParseRuneThrows3EDSBLow is StringsTest {
    function testImpl() internal {
        bytes memory bts = hex"ED7F80";
        Memory.dataPtr(bts).parseRune();
    }
}


contract TestStringsParseRuneThrows3EDSBHigh is StringsTest {
    function testImpl() internal {
        bytes memory bts = hex"EDA080";
        Memory.dataPtr(bts).parseRune();
    }
}


contract TestStringsParseRuneThrows3EDTBLow is StringsTest {
    function testImpl() internal {
        bytes memory bts = hex"ED9F7F";
        Memory.dataPtr(bts).parseRune();
    }
}


contract TestStringsParseRuneThrows3EDTBHigh is StringsTest {
    function testImpl() internal {
        bytes memory bts = hex"ED9FC0";
        Memory.dataPtr(bts).parseRune();
    }
}


contract TestStringsParseRuneThrows3EEtoEFSBLow is StringsTest {
    function testImpl() internal {
        bytes memory bts = hex"EE7F80";
        Memory.dataPtr(bts).parseRune();
    }
}


contract TestStringsParseRuneThrows3EEtoEFSBHigh is StringsTest {
    function testImpl() internal {
        bytes memory bts = hex"EEC080";
        Memory.dataPtr(bts).parseRune();
    }
}


contract TestStringsParseRuneThrows3EEtoEFTBLow is StringsTest {
    function testImpl() internal {
        bytes memory bts = hex"EEBF7F";
        Memory.dataPtr(bts).parseRune();
    }
}


contract TestStringsParseRuneThrows3EEtoEFTBHigh is StringsTest {
    function testImpl() internal {
        bytes memory bts = hex"EEBFC0";
        Memory.dataPtr(bts).parseRune();
    }
}

// 4 byte characters

contract TestStringsParseRuneThrows4F0SBLow is StringsTest {
    function testImpl() internal {
        bytes memory bts = hex"F08F80BF";
        Memory.dataPtr(bts).parseRune();
    }
}


contract TestStringsParseRuneThrows4F0SBHigh is StringsTest {
    function testImpl() internal {
        bytes memory bts = hex"F0C080BF";
        Memory.dataPtr(bts).parseRune();
    }
}


contract TestStringsParseRuneThrows4F0TBLow is StringsTest {
    function testImpl() internal {
        bytes memory bts = hex"F0807FBF";
        Memory.dataPtr(bts).parseRune();
    }
}


contract TestStringsParseRuneThrows4F0TBHigh is StringsTest {
    function testImpl() internal {
        bytes memory bts = hex"F080C0BF";
        Memory.dataPtr(bts).parseRune();
    }
}


contract TestStringsParseRuneThrows4F0FBLow is StringsTest {
    function testImpl() internal {
        bytes memory bts = hex"F080BF7F";
        Memory.dataPtr(bts).parseRune();
    }
}


contract TestStringsParseRuneThrows4F0FBHigh is StringsTest {
    function testImpl() internal {
        bytes memory bts = hex"F080BFC0";
        Memory.dataPtr(bts).parseRune();
    }
}


contract TestStringsParseRuneThrows4F1toF3SBLow is StringsTest {
    function testImpl() internal {
        bytes memory bts = hex"F27F80BF";
        Memory.dataPtr(bts).parseRune();
    }
}


contract TestStringsParseRuneThrows4F1toF3SBHigh is StringsTest {
    function testImpl() internal {
        bytes memory bts = hex"F2C080BF";
        Memory.dataPtr(bts).parseRune();
    }
}


contract TestStringsParseRuneThrows4F1toF3TBLow is StringsTest {
    function testImpl() internal {
        bytes memory bts = hex"F2807FBF";
        Memory.dataPtr(bts).parseRune();
    }
}


contract TestStringsParseRuneThrows4F1toF3TBHigh is StringsTest {
    function testImpl() internal {
        bytes memory bts = hex"F280C0BF";
        Memory.dataPtr(bts).parseRune();
    }
}


contract TestStringsParseRuneThrows4F1toF3FBLow is StringsTest {
    function testImpl() internal {
        bytes memory bts = hex"F280BF7F";
        Memory.dataPtr(bts).parseRune();
    }
}


contract TestStringsParseRuneThrows4F1toF3FBHigh is StringsTest {
    function testImpl() internal {
        bytes memory bts = hex"F280BFC0";
        Memory.dataPtr(bts).parseRune();
    }
}


contract TestStringsParseRuneThrows4F4SBLow is StringsTest {
    function testImpl() internal {
        bytes memory bts = hex"F47F80BF";
        Memory.dataPtr(bts).parseRune();
    }
}


contract TestStringsParseRuneThrows4F4SBHigh is StringsTest {
    function testImpl() internal {
        bytes memory bts = hex"F49080BF";
        Memory.dataPtr(bts).parseRune();
    }
}


contract TestStringsParseRuneThrows4F4TBLow is StringsTest {
    function testImpl() internal {
        bytes memory bts = hex"F4807FBF";
        Memory.dataPtr(bts).parseRune();
    }
}


contract TestStringsParseRuneThrows4F4TBHigh is StringsTest {
    function testImpl() internal {
        bytes memory bts = hex"F480C0BF";
        Memory.dataPtr(bts).parseRune();
    }
}


contract TestStringsParseRuneThrows4F4FBLow is StringsTest {
    function testImpl() internal {
        bytes memory bts = hex"F480BF7F";
        Memory.dataPtr(bts).parseRune();
    }
}


contract TestStringsParseRuneThrows4F4FBHigh is StringsTest {
    function testImpl() internal {
        bytes memory bts = hex"F480BFC0";
        Memory.dataPtr(bts).parseRune();
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
        string memory str = "זה כיף סתם לשמוע איך תנצח קרפד עץ טוב בגן";
        str.validate();
    }
}


contract TestStringsValidateQuickBrownFoxHiragana is StringsTest {
    function testImpl() internal {
        string memory str = "いろはにほへど　ちりぬるを わがよたれぞ　つねならむ うゐのおくやま　けふこえて あさきゆめみじ　ゑひもせず";
        str.validate();
    }
}
/* solhint-enable max-line-length */