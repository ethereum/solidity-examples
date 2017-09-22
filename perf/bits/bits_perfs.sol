pragma solidity ^0.4.16;
pragma experimental "v0.5.0";
pragma experimental ABIEncoderV2;

import {Bits} from "../../src/bits/Bits.sol";
import {STLPerf} from "../STLPerf.sol";


contract PerfBitsSetBit is STLPerf {
    using Bits for uint;

    function perfImpl() internal {
        uint(1).setBit(66);
    }
}


contract PerfBitsClearBit is STLPerf {
    using Bits for uint;

    function perfImpl() internal {
        uint(1).clearBit(66);
    }
}


contract PerfBitsToggleBit is STLPerf {
    using Bits for uint;

    function perfImpl() internal {
        uint(1).toggleBit(66);
    }
}


contract PerfBitsBit is STLPerf {
    using Bits for uint;

    function perfImpl() internal {
        uint(1).bit(66);
    }
}


contract PerfBitsBitSet is STLPerf {
    using Bits for uint;

    function perfImpl() internal {
        uint(1).bitSet(66);
    }
}


contract PerfBitsBitEqual is STLPerf {
    using Bits for uint;

    function perfImpl() internal {
        uint(1).bitEqual(5, 66);
    }
}


contract PerfBitsBitAnd is STLPerf {
    using Bits for uint;

    function perfImpl() internal {
        uint(1).bitAnd(0, 66);
    }
}


contract PerfBitsBitOr is STLPerf {
    using Bits for uint;

    function perfImpl() internal {
        uint(1).bitOr(0, 66);
    }
}


contract PerfBitsBitXor is STLPerf {
    using Bits for uint;

    function perfImpl() internal {
        uint(1).bitXor(0, 66);
    }
}


contract PerfBitsBits is STLPerf {
    using Bits for uint;

    function perfImpl() internal {
        uint(1).bits(5, 66);
    }
}


contract PerfBitsHighestBitSetLow is STLPerf {
    using Bits for uint;

    function perfImpl() internal {
        uint(1).highestBitSet();
    }
}


contract PerfBitsHighestBitSetHigh is STLPerf {
    using Bits for uint;

    function perfImpl() internal {
        (uint(1) << uint(255)).highestBitSet();
    }
}


contract PerfBitsLowestBitSetLow is STLPerf {
    using Bits for uint;

    function perfImpl() internal {
        uint(1).lowestBitSet();
    }
}


contract PerfBitsLowestBitSetHigh is STLPerf {
    using Bits for uint;

    function perfImpl() internal {
        (uint(1) << uint(255)).lowestBitSet();
    }
}
