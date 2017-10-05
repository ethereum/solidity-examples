"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
var option_1 = require("./option");
describe('sanity check for options', function () {
    it('checks that options are well formed', function () {
        var shortFormsFound = {};
        var check = function (optsObj) {
            for (var optName in optsObj) {
                if (optsObj.hasOwnProperty(optName)) {
                    var opt = optsObj[optName];
                    expect(opt.name()).toBe(optName);
                    expect(opt.info()).not.toBe('');
                    var shortForm = opt.shortForm();
                    expect(shortFormsFound[shortForm]).toBeUndefined();
                    shortFormsFound[shortForm] = true;
                }
            }
        };
        check(option_1.OPTIONS);
        check(option_1.GLOBAL_OPTIONS);
    });
});
