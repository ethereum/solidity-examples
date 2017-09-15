const fillerUtils = require('../../script/fillerUtils');

module.exports = function () {
    return {
        "TestPatriciaTreeInsert": testInsert,
        "TestPatriciaTreeInsertTwo": testInsertTwo,
        "TestPatriciaTreeInsertTwoDifferentOrder": testInsertTwo,
        "TestPatriciaTreeInsertThree": testInsertThree,
        "TestPatriciaTreeInsertThreePerm1": testInsertThree,
        "TestPatriciaTreeInsertThreePerm2": testInsertThree
    };
};

function testInsert(name, code) {
    const storage = {
        "0x": "0x1",
        "0x02": "0x39fd944613a52ff5d776068277cf6905576365e6f01a1afb3346de34b946dbf2",
        "0x03": "0x6a96595ccfcb78ff3e886e67a3c94a0c6c8fe147c51512c4f9b5e8aa8d636f07",
        "0x04": "0x749eb9a32604a1e3d5563e475f22a54221a22999f274fb5acd84a00d16053a11",
        "0x05": "0x100"
    };
    const env = fillerUtils.generateDefaultTestEnv();
    const pre = fillerUtils.generateDefaultTestPre(code);
    const tx = fillerUtils.generateDefaultTransaction();
    const expect = [fillerUtils.generateDefaultTestExpect(storage)];
    return fillerUtils.generateTestFiller(name, env, expect, pre, tx);
}

function testInsertTwo(name, code) {
    const storage = {
        "0x": "0x1",
        "0x02": "0x30ca1d513a446f6be18ca4e5cce7ffa71ebce69492e5461885212b2438da4e3a",
        "0x03": "0x49d5ff14955320f0897d9099ff72e29c961d71ad98bcc1a2ef3c6e6d057be09c",
        "0x05": "0x01",
        "0x88efc4c101410b43f28f4e749c2e16486a3d6742fe53f034d9660029bd1d386a": "0x780f7d9be6b7b221c27f7d5e84ff9ff220b60283dd7d012fbd9195bb6bb472aa",
        "0x88efc4c101410b43f28f4e749c2e16486a3d6742fe53f034d9660029bd1d386b": "0x3dc3a4c8df9bb6b024b455ced81b5a359cb6482d45564e67cd4859ab92d29c9c",
        "0x88efc4c101410b43f28f4e749c2e16486a3d6742fe53f034d9660029bd1d386c": "0xfe",
        "0x88efc4c101410b43f28f4e749c2e16486a3d6742fe53f034d9660029bd1d386d": "0x6a96595ccfcb78ff3e886e67a3c94a0c6c8fe147c51512c4f9b5e8aa8d636f07",
        "0x88efc4c101410b43f28f4e749c2e16486a3d6742fe53f034d9660029bd1d386e": "0xd27ae68c9812878f5558f91d7c8a95088688a667c9d3ed6b361280345814e844",
        "0x88efc4c101410b43f28f4e749c2e16486a3d6742fe53f034d9660029bd1d386f": "0xfe"
    };
    const env = fillerUtils.generateDefaultTestEnv();
    const pre = fillerUtils.generateDefaultTestPre(code);
    const tx = fillerUtils.generateDefaultTransaction();
    const expect = [fillerUtils.generateDefaultTestExpect(storage)];
    return fillerUtils.generateTestFiller(name, env, expect, pre, tx);
}

function testInsertThree(name, code) {
    const storage = {
        "0x": "0x1",
        "0x02": "0xf637e05e31f0cb7934038a6e71997250f718b9c207f87860da323efd66650ba2",
        "0x03": "0x2652c8edffac832f9321d392920c32d08f4e3176add8ad9995f5c3ee26629cf8",
        "0x05": "0x01",
        "0x7c7c514f373249ead24f5dc39357d5e424b216fd9e175ce0ff18cc18afb8ba3c": "0xdf27f30d8df132c5d40d1d896613f76e14d4c24942420a30483e3cd7c1984a7f",
        "0x7c7c514f373249ead24f5dc39357d5e424b216fd9e175ce0ff18cc18afb8ba3d": "0x12a8c4634489c57f36818677579c4d384f79ae691b2c8e6e6e47c78cf96c9380",
        "0x7c7c514f373249ead24f5dc39357d5e424b216fd9e175ce0ff18cc18afb8ba3e": "0xfc",
        "0x7c7c514f373249ead24f5dc39357d5e424b216fd9e175ce0ff18cc18afb8ba3f": "0x6a96595ccfcb78ff3e886e67a3c94a0c6c8fe147c51512c4f9b5e8aa8d636f07",
        "0x7c7c514f373249ead24f5dc39357d5e424b216fd9e175ce0ff18cc18afb8ba40": "0x49eb9a32604a1e3d5563e475f22a54221a22999f274fb5acd84a00d16053a110",
        "0x7c7c514f373249ead24f5dc39357d5e424b216fd9e175ce0ff18cc18afb8ba41": "0xfc",
        "0xa5ed6b09a161835c58fb1bbc0e0bf9d6a0a2ae58c5518323c3be3be84ea4bdc6": "0x780f7d9be6b7b221c27f7d5e84ff9ff220b60283dd7d012fbd9195bb6bb472aa",
        "0xa5ed6b09a161835c58fb1bbc0e0bf9d6a0a2ae58c5518323c3be3be84ea4bdc7": "0x3dc3a4c8df9bb6b024b455ced81b5a359cb6482d45564e67cd4859ab92d29c9c",
        "0xa5ed6b09a161835c58fb1bbc0e0bf9d6a0a2ae58c5518323c3be3be84ea4bdc8": "0xfe",
        "0xa5ed6b09a161835c58fb1bbc0e0bf9d6a0a2ae58c5518323c3be3be84ea4bdc9": "0x4821d8d642d8ac97cf56e5d4c8537abc235e0a69f2599ca76adf27e2e9dcf9de",
        "0xa5ed6b09a161835c58fb1bbc0e0bf9d6a0a2ae58c5518323c3be3be84ea4bdca": "0x8000000000000000000000000000000000000000000000000000000000000000",
        "0xa5ed6b09a161835c58fb1bbc0e0bf9d6a0a2ae58c5518323c3be3be84ea4bdcb": "0x01"
    };
    const env = fillerUtils.generateDefaultTestEnv();
    const pre = fillerUtils.generateDefaultTestPre(code);
    const tx = fillerUtils.generateDefaultTransaction();
    const expect = [fillerUtils.generateDefaultTestExpect(storage)];
    return fillerUtils.generateTestFiller(name, env, expect, pre, tx);
}
 