import {
    generateDefaultTestEnv, generateDefaultTestExpect, generateDefaultTestPre,
    generateDefaultTransaction, generateTestFiller
} from '../../script/utils/filler';

export const generate = () => {
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
        "0x01": "0x39fd944613a52ff5d776068277cf6905576365e6f01a1afb3346de34b946dbf2",
        "0x02": "0x6a96595ccfcb78ff3e886e67a3c94a0c6c8fe147c51512c4f9b5e8aa8d636f07",
        "0x03": "0x749eb9a32604a1e3d5563e475f22a54221a22999f274fb5acd84a00d16053a11",
        "0x04": "0x100"
    };
    const env = generateDefaultTestEnv();
    const pre = generateDefaultTestPre(code);
    const tx = generateDefaultTransaction();
    const expect = [generateDefaultTestExpect(storage)];
    return generateTestFiller(name, env, expect, pre, tx);
}

function testInsertTwo(name, code) {
    const storage = {
        "0x": "0x1",
        "0x01": "0x30ca1d513a446f6be18ca4e5cce7ffa71ebce69492e5461885212b2438da4e3a",
        "0x02": "0x49d5ff14955320f0897d9099ff72e29c961d71ad98bcc1a2ef3c6e6d057be09c",
        "0x04": "0x01",
        "0x730bae04d846980bd21919029d0c9183e1facebac0ce9b466f3572b423700d5b": "0x780f7d9be6b7b221c27f7d5e84ff9ff220b60283dd7d012fbd9195bb6bb472aa",
        "0x730bae04d846980bd21919029d0c9183e1facebac0ce9b466f3572b423700d5c": "0x3dc3a4c8df9bb6b024b455ced81b5a359cb6482d45564e67cd4859ab92d29c9c",
        "0x730bae04d846980bd21919029d0c9183e1facebac0ce9b466f3572b423700d5d": "0xfe",
        "0x730bae04d846980bd21919029d0c9183e1facebac0ce9b466f3572b423700d5e": "0x6a96595ccfcb78ff3e886e67a3c94a0c6c8fe147c51512c4f9b5e8aa8d636f07",
        "0x730bae04d846980bd21919029d0c9183e1facebac0ce9b466f3572b423700d5f": "0xd27ae68c9812878f5558f91d7c8a95088688a667c9d3ed6b361280345814e844",
        "0x730bae04d846980bd21919029d0c9183e1facebac0ce9b466f3572b423700d60": "0xfe"
    };
    const env = generateDefaultTestEnv();
    const pre = generateDefaultTestPre(code);
    const tx = generateDefaultTransaction();
    const expect = [generateDefaultTestExpect(storage)];
    return generateTestFiller(name, env, expect, pre, tx);
}

function testInsertThree(name, code) {
    const storage = {
        "0x": "0x1",
        "0x01": "0xf637e05e31f0cb7934038a6e71997250f718b9c207f87860da323efd66650ba2",
        "0x02": "0x2652c8edffac832f9321d392920c32d08f4e3176add8ad9995f5c3ee26629cf8",
        "0x04": "0x01",
        "0x7ff1fbcd79436ac14b76b8e2a224164a04babb30e9da90e9666ec7fcfbe8bbe4": "0x780f7d9be6b7b221c27f7d5e84ff9ff220b60283dd7d012fbd9195bb6bb472aa",
        "0x7ff1fbcd79436ac14b76b8e2a224164a04babb30e9da90e9666ec7fcfbe8bbe5": "0x3dc3a4c8df9bb6b024b455ced81b5a359cb6482d45564e67cd4859ab92d29c9c",
        "0x7ff1fbcd79436ac14b76b8e2a224164a04babb30e9da90e9666ec7fcfbe8bbe6": "0xfe",
        "0x7ff1fbcd79436ac14b76b8e2a224164a04babb30e9da90e9666ec7fcfbe8bbe7": "0x4821d8d642d8ac97cf56e5d4c8537abc235e0a69f2599ca76adf27e2e9dcf9de",
        "0x7ff1fbcd79436ac14b76b8e2a224164a04babb30e9da90e9666ec7fcfbe8bbe8": "0x8000000000000000000000000000000000000000000000000000000000000000",
        "0x7ff1fbcd79436ac14b76b8e2a224164a04babb30e9da90e9666ec7fcfbe8bbe9": "0x01",
        "0xd390a43002d5609bdea07c5e4ff0bdbd08f41634aecdce595acfe1b9d729a053": "0xdf27f30d8df132c5d40d1d896613f76e14d4c24942420a30483e3cd7c1984a7f",
        "0xd390a43002d5609bdea07c5e4ff0bdbd08f41634aecdce595acfe1b9d729a054": "0x12a8c4634489c57f36818677579c4d384f79ae691b2c8e6e6e47c78cf96c9380",
        "0xd390a43002d5609bdea07c5e4ff0bdbd08f41634aecdce595acfe1b9d729a055": "0xfc",
        "0xd390a43002d5609bdea07c5e4ff0bdbd08f41634aecdce595acfe1b9d729a056": "0x6a96595ccfcb78ff3e886e67a3c94a0c6c8fe147c51512c4f9b5e8aa8d636f07",
        "0xd390a43002d5609bdea07c5e4ff0bdbd08f41634aecdce595acfe1b9d729a057": "0x49eb9a32604a1e3d5563e475f22a54221a22999f274fb5acd84a00d16053a110",
        "0xd390a43002d5609bdea07c5e4ff0bdbd08f41634aecdce595acfe1b9d729a058": "0xfc"
    };
    const env = generateDefaultTestEnv();
    const pre = generateDefaultTestPre(code);
    const tx = generateDefaultTransaction();
    const expect = [generateDefaultTestExpect(storage)];
    return generateTestFiller(name, env, expect, pre, tx);
}
