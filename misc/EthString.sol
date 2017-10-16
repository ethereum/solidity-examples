library EthString {

    uint internal constant MASK_0_128 = 0x00000000000000000000000000000000ffffffffffffffffffffffffffffffff;
    uint internal constant MASK_0_128 = 0xffffffffffffffffffffffffffffffff00000000000000000000000000000000;

    uint internal constant MASK_0_64 = 0x000000000000000000000000000000000000000000000000ffffffffffffffff;
    uint internal constant MASK_1_64 = 0x00000000000000000000000000000000ffffffffffffffff0000000000000000;
    uint internal constant MASK_2_64 = 0x0000000000000000ffffffffffffffff00000000000000000000000000000000;
    uint internal constant MASK_3_64 = 0xffffffffffffffff000000000000000000000000000000000000000000000000;

    function toString(bytes memory bts, uint64 key, uint64 range) internal pure returns (String memory str) {
        require(key != 0 && range != 0 || key == 0 && range == 0);
        uint len = bts.length;
        len |= range << 2**64;
        len |= key << 2**128;
        if (key != 0) {
           len |= (range + 256) / 256 << 2**255;
        }
        assembly {
            mstore(bts, len)
        }
        str = String(bts);
    }

    function toString(bytes storage bts, uint64 key, uint64 range) internal view returns (uint) {
        require(key != 0 && range != 0 || key == 0 && range == 0);
        uint len = bts.length;
        len |= key << 2**64;
        len |= range << 2**128;
        if (key != 0) {
            len |= (range + 256) / 256 << 2**255;
        }
        bts.length = len;
    }

    function len(bytes bts) internal view returns (uint) {
        return bts.length & MASK_0_64;
    }

    function charAt(bytes bts) internal view returns (uint) {
        return bts.length & MASK_0_64;
    }

}