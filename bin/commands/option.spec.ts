import {GLOBAL_OPTIONS, OPTIONS} from "./option";

describe('sanity check for options', () => {
    it('checks that options are well formed', () => {
        const shortFormsFound = {};

        const check = (optsObj) => {
            for (const optName in optsObj) {
                if (optsObj.hasOwnProperty(optName)) {
                    const opt = optsObj[optName];
                    expect(opt.name()).toBe(optName);
                    expect(opt.info()).not.toBe('');
                    const shortForm = opt.shortForm();
                    expect(shortFormsFound[shortForm]).toBeUndefined();
                    shortFormsFound[shortForm] = true;
                }
            }
        };

        check(OPTIONS);
        check(GLOBAL_OPTIONS);
    });
});
