var isequal = require("lodash.isequal");

function ReferenceCache() {
    this.init();
}

if (typeof Map !== "undefined") {
    ReferenceCache.prototype = {
        init: function () { this.map = new Map(); },
        set: function (key, value) {
            this.map.set(key, value);
        },
        get: function (key) {
            return this.map.get(key);
        }
    };
} else {
    ReferenceCache.prototype = {
        init: function () { this.map = []; },
        set: function (key, value) {
            this.map.push([key, value]);
        },
        get: function (key) {
            var i = this.map.length;
            while (i--) {
                if (isequal(this.map[i][0], key)) {
                    return this.map[i][1];
                }
            }
        }
    };
}

module.exports = ReferenceCache;
