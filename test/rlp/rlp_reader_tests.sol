pragma solidity ^0.4.15;

import {RLP} from "../../src/rlp/RLPReader.sol";
import {STLTest} from "../STLTest.sol";

/*******************************************************/

contract RLPReaderTest is STLTest {
    using RLP for RLP.RLPItem;
    using RLP for RLP.Iterator;
    using RLP for bytes;
}

/*******************************************************/


contract TestRLPReaderToRLPItem1Success is RLPReaderTest {
    function testImpl() internal {
        bytes memory bts = hex"00";
        var item = bts.toRLPItem();
        uint memPtr = item._unsafe_memPtr;
        bytes32 val = 0;
        assembly {
            val := mload(memPtr)
        }
        assert(val == 0 && item._unsafe_length == 1);
    }
}

contract TestRLPReaderToRLPItem2Success is RLPReaderTest {
    function testImpl() internal {
        bytes memory bts = hex"05";
        var item = bts.toRLPItem();
        uint memPtr = item._unsafe_memPtr;
        bytes32 val = 0;
        assembly {
            val := mload(memPtr)
        }
        assert(val == hex"05" && item._unsafe_length == 1);
    }
}


contract TestRLPReaderToRLPItem3Success is RLPReaderTest {
    function testImpl() internal {
        bytes memory bts = hex"80";
        var item = bts.toRLPItem();
        uint memPtr = item._unsafe_memPtr;
        bytes32 val = 0;
        assembly {
            val := mload(memPtr)
        }
        assert(val == hex"80" && item._unsafe_length == 1);
    }
}


contract TestRLPReaderToRLPItem4Success is RLPReaderTest {
    function testImpl() internal {
        bytes memory bts = hex"820505";
        var item = bts.toRLPItem();
        uint memPtr = item._unsafe_memPtr;
        bytes32 val = 0;
        assembly {
            val := mload(memPtr)
        }
        assert(val == hex"820505" && item._unsafe_length == 3);
    }
}


contract TestRLPReaderToRLPItem5Success is RLPReaderTest {
    function testImpl() internal {
        bytes memory bts = hex"880102030405060708";
        var item = bts.toRLPItem();
        uint memPtr = item._unsafe_memPtr;
        bytes32 val = 0;
        assembly {
            val := mload(memPtr)
        }
        assert(val == hex"880102030405060708" && item._unsafe_length == 9);
    }
}


contract TestRLPReaderToRLPItem6Success is RLPReaderTest {
    function testImpl() internal {
        bytes memory bts = hex"B701020304050607080102030405060708010203040506070801020304050607080102030405060708010203040506070801020304050607";
        var item = bts.toRLPItem();
        uint memPtr = item._unsafe_memPtr;
        bytes32 val1 = 0;
        bytes32 val2 = 0;
        assembly {
            val1 := mload(memPtr)
            val2 := mload(add(memPtr, 0x20))
        }
        assert(val1 == hex"B701020304050607080102030405060708010203040506070801020304050607"
            && val2 == hex"080102030405060708010203040506070801020304050607"
            && item._unsafe_length == 56
        );
    }
}

contract TestRLPReaderToRLPItemStrictManySuccess is RLPReaderTest {
    function testImpl() internal {
        bytes memory bts = hex"00";
        var item = bts.toRLPItem();
        bts = hex"05";
        item = bts.toRLPItem(true);
        bts = hex"80";
        item = bts.toRLPItem(true);
        bts = hex"820505";
        item = bts.toRLPItem(true);
        bts = hex"880102030405060708";
        item = bts.toRLPItem(true);
        bts = hex"B701020304050607080102030405060708010203040506070801020304050607080102030405060708010203040506070801020304050607";
        item = bts.toRLPItem(true);
    }
}


contract TestRLPReaderToRLPItemStrictThrows1 is RLPReaderTest {
    function testImpl() internal {
        bytes memory bts = hex"817F";
        bts.toRLPItem(true);
    }
}

contract TestRLPReaderToRLPItemStrictThrows2 is RLPReaderTest {
    function testImpl() internal {
        bytes memory bts = hex"81";
        bts.toRLPItem(true);
    }
}


contract TestRLPReaderToRLPItemStrictThrows3 is RLPReaderTest {
    function testImpl() internal {
        bytes memory bts = hex"B70102030405060708010203040506070801020304050607080102030405060708010203040506070801020304050607080102030405060706";
        bts.toRLPItem(true);
    }
}


contract TestRLPReaderToRLPItemStrictThrows4 is RLPReaderTest {
    function testImpl() internal {
        bytes memory bts = hex"B7010203040506070801020304050607080102030405060708010203040506070801020304050607080102030405060708010203040506";
        bts.toRLPItem(true);
    }
}


contract TestRLPReaderToRLPItemStrictThrows5 is RLPReaderTest {
    function testImpl() internal {
        bytes memory bts = hex"C001";
        bts.toRLPItem(true);
    }
}


contract TestRLPReaderToRLPItemStrictThrows6 is RLPReaderTest {
    function testImpl() internal {
        bytes memory bts = hex"C2010203";
        bts.toRLPItem(true);
    }
}


contract TestRLPReaderIsListManySuccess is RLPReaderTest {
    function testImpl() internal {
        bytes memory bts = hex"C0";
        assert(bts.toRLPItem().isList());
        bts = hex"C80102030405060708";
        assert(bts.toRLPItem().isList());
        bts = hex"F873B70102030405060708010203040506070801020304050607080102030405060708010203040506070801020304050607080102030405060705B8380102030405060708010203040506070801020304050607080102030405060708010203040506070801020304050607080102030405060708";
        assert(bts.toRLPItem().isList());
        bts = hex"C3C0C0C0";
        assert(bts.toRLPItem().isList());
        bts = hex"C6C20102C20102";
        assert(bts.toRLPItem().isList());
        bts = hex"C7C2010201C20102";
        assert(bts.toRLPItem().isList());
        bts = hex"F7B6010203040506070801020304050607080102030405060708010203040506070801020304050607080102030405060708010203040506";
        assert(bts.toRLPItem().isList());
        bts = hex"F838B701020304050607080102030405060708010203040506070801020304050607080102030405060708010203040506070801020304050607";
        assert(bts.toRLPItem().isList());
        bts = hex"F90103B9010001020304050607080102030405060708010203040506070801020304050607080102030405060708010203040506070801020304050607080102030405060708010203040506070801020304050607080102030405060708010203040506070801020304050607080102030405060708010203040506070801020304050607080102030405060708010203040506070801020304050607080102030405060708010203040506070801020304050607080102030405060708010203040506070801020304050607080102030405060708010203040506070801020304050607080102030405060708010203040506070801020304050607080102030405060708";
        assert(bts.toRLPItem().isList());
    }
}


contract TestRLPReaderIsList1Throws is RLPReaderTest {
    function testImpl() internal {
        bytes memory bts = hex"00";
        assert(bts.toRLPItem().isList());
    }
}


contract TestRLPReaderIsList2Throws is RLPReaderTest {
    function testImpl() internal {
        bytes memory bts = hex"80";
        assert(bts.toRLPItem().isList());
    }
}


contract TestRLPReaderIsList3Throws is RLPReaderTest {
    function testImpl() internal {
        bytes memory bts = hex"820505";
        assert(bts.toRLPItem().isList());
    }
}


contract TestRLPReaderIsList4Throws is RLPReaderTest {
    function testImpl() internal {
        bytes memory bts = hex"880102030405060708";
        assert(bts.toRLPItem().isList());
    }
}


contract TestRLPReaderIsList5Throws is RLPReaderTest {
    function testImpl() internal {
        bytes memory bts = hex"B8380102030405060708010203040506070801020304050607080102030405060708010203040506070801020304050607080102030405060708";
        assert(bts.toRLPItem().isList());
    }
}


contract TestRLPReaderIsList6Throws is RLPReaderTest {
    function testImpl() internal {
        bytes memory bts = hex"B9010001020304050607080102030405060708010203040506070801020304050607080102030405060708010203040506070801020304050607080102030405060708010203040506070801020304050607080102030405060708010203040506070801020304050607080102030405060708010203040506070801020304050607080102030405060708010203040506070801020304050607080102030405060708010203040506070801020304050607080102030405060708010203040506070801020304050607080102030405060708010203040506070801020304050607080102030405060708010203040506070801020304050607080102030405060708";
        assert(bts.toRLPItem().isList());
    }
}


contract TestRLPReaderIsDataManySuccess is RLPReaderTest {
    function testImpl() internal {
        bytes memory bts = hex"00";
        assert(bts.toRLPItem().isData());
        bts = hex"80";
        assert(bts.toRLPItem().isData());
        bts = hex"820505";
        assert(bts.toRLPItem().isData());
        bts = hex"880102030405060708";
        assert(bts.toRLPItem().isData());
        bts = hex"B8380102030405060708010203040506070801020304050607080102030405060708010203040506070801020304050607080102030405060708";
        assert(bts.toRLPItem().isData());
        bts = hex"B9010001020304050607080102030405060708010203040506070801020304050607080102030405060708010203040506070801020304050607080102030405060708010203040506070801020304050607080102030405060708010203040506070801020304050607080102030405060708010203040506070801020304050607080102030405060708010203040506070801020304050607080102030405060708010203040506070801020304050607080102030405060708010203040506070801020304050607080102030405060708010203040506070801020304050607080102030405060708010203040506070801020304050607080102030405060708";
        assert(bts.toRLPItem().isData());
    }
}


contract TestRLPReaderIsData1Throws is RLPReaderTest {
    function testImpl() internal {
        bytes memory bts = hex"C0";
        assert(bts.toRLPItem().isData());
    }
}


contract TestRLPReaderIsData2Throws is RLPReaderTest {
    function testImpl() internal {
        bytes memory bts = hex"C80102030405060708";
        assert(bts.toRLPItem().isData());
    }
}


contract TestRLPReaderIsData3Throws is RLPReaderTest {
    function testImpl() internal {
        bytes memory bts = hex"F873B70102030405060708010203040506070801020304050607080102030405060708010203040506070801020304050607080102030405060705B8380102030405060708010203040506070801020304050607080102030405060708010203040506070801020304050607080102030405060708";
        assert(bts.toRLPItem().isData());
    }
}


contract TestRLPReaderIsData4Throws is RLPReaderTest {
    function testImpl() internal {
        bytes memory bts = hex"C3C0C0C0";
        assert(bts.toRLPItem().isData());
    }
}


contract TestRLPReaderIsData5Throws is RLPReaderTest {
    function testImpl() internal {
        bytes memory bts = hex"C7C2010201C20102";
        assert(bts.toRLPItem().isData());
    }
}


contract TestRLPReaderIsData6Throws is RLPReaderTest {
    function testImpl() internal {
        bytes memory bts = hex"F838B701020304050607080102030405060708010203040506070801020304050607080102030405060708010203040506070801020304050607";
        assert(bts.toRLPItem().isData());
    }
}


contract TestRLPReaderIsEmptyStringSuccess is RLPReaderTest {
    function testImpl() internal {
        bytes memory bts = hex"80";
        assert(bts.toRLPItem().isEmpty());
    }
}


contract TestRLPReaderIsEmptyListSuccess is RLPReaderTest {
    function testImpl() internal {
        bytes memory bts = hex"C0";
        assert(bts.toRLPItem().isEmpty());
    }
}


contract TestRLPReaderItems1Success is RLPReaderTest {
    function testImpl() internal {
        bytes memory bts = hex"C0";
        assert(bts.toRLPItem().items() == 0);
    }
}


contract TestRLPReaderItems2Success is RLPReaderTest {
    function testImpl() internal {
        bytes memory bts = hex"C80102030405060708";
        assert(bts.toRLPItem().items() == 8);
    }
}


contract TestRLPReaderItems3Success is RLPReaderTest {
    function testImpl() internal {
        bytes memory bts = hex"F873B70102030405060708010203040506070801020304050607080102030405060708010203040506070801020304050607080102030405060705B8380102030405060708010203040506070801020304050607080102030405060708010203040506070801020304050607080102030405060708";
        assert(bts.toRLPItem().items() == 3);
    }
}


contract TestRLPReaderItems4Success is RLPReaderTest {
    function testImpl() internal {
        bytes memory bts = hex"C3C0C0C0";
        assert(bts.toRLPItem().items() == 3);
    }
}


contract TestRLPReaderItems5Success is RLPReaderTest {
    function testImpl() internal {
        bytes memory bts = hex"F838B701020304050607080102030405060708010203040506070801020304050607080102030405060708010203040506070801020304050607";
        assert(bts.toRLPItem().items() == 1);
    }
}


contract TestRLPReaderItems6Success is RLPReaderTest {
    function testImpl() internal {
        bytes memory bts = hex"880102030405060708";
        assert(bts.toRLPItem().items() == 0);
    }
}


contract TestRLPReaderItems7Success is RLPReaderTest {
    function testImpl() internal {
        bytes memory bts = hex"B8380102030405060708010203040506070801020304050607080102030405060708010203040506070801020304050607080102030405060708";
        assert(bts.toRLPItem().items() == 0);
    }
}


contract TestRLPReaderIterateOverList1Success is RLPReaderTest {
    function testImpl() internal {
        bytes memory bts = hex"C3C0C0C0";
        var it = bts.toRLPItem().iterator();
        assert(it.hasNext());
        var item = it.next();
        assert(item.isList());
        assert(item.items() == 0);
        item = it.next();
        assert(item.isList());
        assert(item.items() == 0);
        item = it.next();
        assert(item.isList());
        assert(item.items() == 0);
        assert(!it.hasNext());
    }
}


contract TestRLPReaderIterateOverList2Success is RLPReaderTest {
    function testImpl() internal {
        bytes memory bts = hex"C7C2010201C20102";
        var it = bts.toRLPItem().iterator();
        assert(it.hasNext());
        var item = it.next();
        assert(item.isList());
        assert(item.items() == 2);
        item = it.next();
        assert(item.isData());
        item = it.next();
        assert(item.isList());
        assert(item.items() == 2);
        assert(!it.hasNext());
    }
}


contract TestRLPReaderIterateOverList3Success is RLPReaderTest {
    function testImpl() internal {
        bytes memory bts = hex"F7B6010203040506070801020304050607080102030405060708010203040506070801020304050607080102030405060708010203040506";
        var it = bts.toRLPItem().iterator();
        assert(it.hasNext());
        var item = it.next();
        assert(item.isData());
        assert(!it.hasNext());
    }
}


contract TestRLPReaderIterateOverListInListSuccess is RLPReaderTest {
    function testImpl() internal {
        bytes memory bts = hex"C7C2010201C20102";
        var it = bts.toRLPItem().iterator();
        assert(it.hasNext());
        var item = it.next();
        assert(item.isList());
        assert(item.items() == 2);
        it = item.iterator();
        item = it.next();
        assert(item.isData());
        item = it.next();
        assert(item.isData());
        assert(!it.hasNext());
    }
}


contract TestRLPReaderIterateOverListInListCheckValuesSuccess is RLPReaderTest {
    function testImpl() internal {
        bytes memory bts = hex"C7C2010201C20102";
        var it = bts.toRLPItem().iterator();
        var item = it.next();
        assert(item.items() == 2);
        var it2 = item.iterator();
        item = it2.next();
        assert(item.toUint() == 1);
        item = it2.next();
        assert(item.toUint() == 2);
        item = it.next();
        assert(item.toUint() == 1);
        item = it.next();
        var it3 = item.iterator();
        item = it3.next();
        assert(item.toUint() == 1);
        item = it3.next();
        assert(item.toUint() == 2);
    }
}


contract TestRLPReaderToUint1Success is RLPReaderTest {
    function testImpl() internal {
        bytes memory bts = hex"00";
        assert(bts.toRLPItem().toUint() == uint(0));
    }
}


contract TestRLPReaderToUint2Success is RLPReaderTest {
    function testImpl() internal {
        bytes memory bts = hex"820505";
        assert(bts.toRLPItem().toUint() == uint(0x0505));
    }
}


contract TestRLPReaderToUint3Success is RLPReaderTest {
    function testImpl() internal {
        bytes memory bts = hex"880102030405060708";
        assert(bts.toRLPItem().toUint() == uint(0x0102030405060708));
    }
}


contract TestRLPReaderToUint1Throws is RLPReaderTest {
    function testImpl() internal {
        bytes memory bts = hex"80";
        bts.toRLPItem().toUint();
    }
}


contract TestRLPReaderToUint2Throws is RLPReaderTest {
    function testImpl() internal {
        bytes memory bts = hex"C0";
        bts.toRLPItem().toUint();
    }
}


contract TestRLPReaderToAddressSuccess is RLPReaderTest {
    function testImpl() internal {
        bytes memory bts = hex"940102030405060708010203040506070801020304";
        assert(bts.toRLPItem().toAddress() == address(0x0102030405060708010203040506070801020304));
    }
}


contract TestRLPReaderToAddress1Throws is RLPReaderTest {
    function testImpl() internal {
        bytes memory bts = hex"9301020304050607080102030405060708010203";
        bts.toRLPItem().toAddress();
    }
}


contract TestRLPReaderToAddress2Throws is RLPReaderTest {
    function testImpl() internal {
        bytes memory bts = hex"95010203040506070801020304050607080102030405";
        bts.toRLPItem().toAddress();
    }
}


contract TestRLPReaderToAddress3Throws is RLPReaderTest {
    function testImpl() internal {
        bytes memory bts = hex"C0";
        bts.toRLPItem().toAddress();
    }
}


contract TestRLPReaderToByte1Success is RLPReaderTest {
    function testImpl() internal {
        bytes memory bts = hex"00";
        assert(bts.toRLPItem().toByte() == byte(0));
    }
}


contract TestRLPReaderToByte2Success is RLPReaderTest {
    function testImpl() internal {
        bytes memory bts = hex"7f";
        assert(bts.toRLPItem().toByte() == byte(0x7f));
    }
}


contract TestRLPReaderToBool1Success is RLPReaderTest {
    function testImpl() internal {
        bytes memory bts = hex"01";
        assert(bts.toRLPItem().toBool());
    }
}


contract TestRLPReaderToBool2Success is RLPReaderTest {
    function testImpl() internal {
        bytes memory bts = hex"00";
        assert(!bts.toRLPItem().toBool());
    }
}


contract TestRLPReaderToBool1Throws is RLPReaderTest {
    function testImpl() internal {
        bytes memory bts = hex"02";
        bts.toRLPItem().toBool();
    }
}


contract TestRLPReaderToBool2Throws is RLPReaderTest {
    function testImpl() internal {
        bytes memory bts = hex"80";
        bts.toRLPItem().toBool();
    }
}


contract TestRLPReaderToBool3Throws is RLPReaderTest {
    function testImpl() internal {
        bytes memory bts = hex"C0";
        bts.toRLPItem().toBool();
    }
}


contract TestRLPReaderToBytes1 is RLPReaderTest {
    function testImpl() internal {
        bytes memory bts1 = hex"C80102030405060708";
        var bts2 = bts1.toRLPItem().toBytes();
        assert(bts1.length == bts2.length);
        for(uint i = 0; i < bts1.length; i++) {
            bts1[i] == bts2[i];
        }
    }
}